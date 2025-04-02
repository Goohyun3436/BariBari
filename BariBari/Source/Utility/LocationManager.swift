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
    
    var manager: CLLocationManager!
    let isTracking = BehaviorRelay<Bool>(value: false)
    let trackingCoordinates = BehaviorRelay<[CLLocationCoordinate2D]>(value: [])
    private let disposeBag = DisposeBag()
    
    func trigger() {
        manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.activityType = .automotiveNavigation
        manager.distanceFilter = 10
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
            manager.stopUpdatingLocation()
            isTracking.accept(false)
        }
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
            // 정상 로직 실행
            // 위치 값을 가져오도록 스타트 시점
            print("authorizedWhenInUse")
//            locationManager.startUpdatingLocation()
        default:
            print("오류 발생")
        }
    }
    
    
}
