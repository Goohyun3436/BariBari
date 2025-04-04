//
//  LocationManager.swift
//  BariBari
//
//  Created by Goo on 4/1/25.
//

import Foundation
import CoreLocation
import RxSwift
import RxCocoa
import RxCoreLocation

final class LocationManager {
    
    static let shared = LocationManager()
    
    private init() {}
    
    let manager = CLLocationManager()
    let isTracking = BehaviorRelay<Bool>(value: false)
    let trackingCoordinates = BehaviorRelay<[CLLocationCoordinate2D]>(value: [])
    let totalDistance = BehaviorRelay<CLLocationDistance>(value: 0)
    private let disposeBag = DisposeBag()
    
    func trigger() {
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.activityType = .automotiveNavigation
        manager.distanceFilter = 1
//        manager.activityType = .automotiveNavigation
//        manager.distanceFilter = 10
        manager.allowsBackgroundLocationUpdates = true
        manager.pausesLocationUpdatesAutomatically = false
        manager.showsBackgroundLocationIndicator = true
        
        manager.rx.didChangeAuthorization
            .bind(with: self, onNext: { owner, event in
                owner.checkCurrentLocationPermission()
            })
            .disposed(by: disposeBag)
        
        manager.rx.didError
            .bind(with: self, onNext: { owner, event in
                print("위치 업데이트 오류: \(event.error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }
    
    func startTracking() {
        if !isTracking.value {
            trackingCoordinates.accept([]) // 새로운 추적 시작 시 기존 좌표 초기화
            manager.startUpdatingLocation()
            isTracking.accept(true)
        }
    }
    
    func stopTracking() {
        if isTracking.value {
            trackingCoordinates.accept([])
            manager.stopUpdatingLocation()
            isTracking.accept(false)
        }
    }
    
    var hasMinimumCoordinates: Bool {
        return trackingCoordinates.value.count >= 2
    }
    
    func observeLocationUpdates() -> Observable<[CLLocation]> {
        return manager.rx.didUpdateLocations
            .withLatestFrom(isTracking) { (locations: $0.1, isTracking: $1) }
            .filter { $0.isTracking }
            .map { $0.locations }
            .do(onNext: { [weak self] locations in
                guard let location = locations.last else { return }
                
                // 새 위치를 추적 좌표에 추가
                var currentCoordinates = self?.trackingCoordinates.value ?? []
                currentCoordinates.append(location.coordinate)
                self?.trackingCoordinates.accept(currentCoordinates)
            })
    }
    
    func observeTotalDistance() -> Observable<CLLocationDistance> {
        return trackingCoordinates
            .map { [weak self] coordinates -> CLLocationDistance in
                guard let self = self, coordinates.count > 1 else { return 0 }
                return self.calculateTotalDistance()
            }
            .do(onNext: { [weak self] distance in
                self?.totalDistance.accept(distance)
            })
    }
    
    private func calculateTotalDistance() -> CLLocationDistance {
        let coordinates = trackingCoordinates.value
        guard coordinates.count > 1 else { return 0 }
        
        var totalDistance: CLLocationDistance = 0
        
        for i in 0..<coordinates.count - 1 {
            let fromLocation = CLLocation(latitude: coordinates[i].latitude, longitude: coordinates[i].longitude)
            let toLocation = CLLocation(latitude: coordinates[i+1].latitude, longitude: coordinates[i+1].longitude)
            
            let distance = fromLocation.distance(from: toLocation)
            totalDistance += distance
        }
        
        return totalDistance
    }
    
    private func checkCurrentLocationPermission() {
        print(#function)
        let status = manager.authorizationStatus
        
        switch status {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
//        case .restricted: // 사용자의 의지와 상관 없이 막힌 상태
        case .denied:
            print("설정으로 이동하는 얼럿 띄우기")
        case .authorizedAlways:
            print("authorizedAlways")
        case .authorizedWhenInUse:
            print("authorizedWhenInUse")
        default:
            print("오류 발생")
        }
    }
    
}
