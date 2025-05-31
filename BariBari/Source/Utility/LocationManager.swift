//
//  LocationManager.swift
//  BariBari
//
//  Created by Goo on 4/1/25.
//

import UIKit
import CoreLocation
import RxSwift
import RxCocoa
import RxCoreLocation

protocol LocationManagerProtocol {
    var hasMinimumCoordinates: Bool { get }
    func trigger()
    func requestLocation() -> Bool
    func startTracking()
    func stopTracking()
    func observeLocationUpdates() -> Observable<[CLLocation]>
    func observeTotalDistance() -> Observable<CLLocationDistance>
}

final class LocationManager: LocationManagerProtocol {
    
    static let shared = LocationManager()
    
    let manager = CLLocationManager()
    let isTracking = BehaviorRelay<Bool>(value: false)
    let trackingCoordinates = BehaviorRelay<[CLLocationCoordinate2D]>(value: [])
    let totalDistance = BehaviorRelay<CLLocationDistance>(value: 0)
    private let disposeBag = DisposeBag()
    
    private init() {
        manager.rx.didChangeAuthorization
            .bind(with: self, onNext: { owner, event in
                _ = owner.checkCurrentLocationPermission()
            })
            .disposed(by: disposeBag)
        
        manager.rx.didError
            .bind(with: self, onNext: { owner, event in
                print("위치 업데이트 오류: \(event.error.localizedDescription)")
                //refactor 지금까지의 경로 UserDefaults 에 저장해놓고 root 전환 + toast, 푸시 알림
                owner.stopTracking()
            })
            .disposed(by: disposeBag)
    }
    
    func trigger() {
        _ = checkCurrentLocationPermission()
        
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.activityType = .automotiveNavigation
        manager.distanceFilter = 10
        manager.allowsBackgroundLocationUpdates = true
        manager.pausesLocationUpdatesAutomatically = false
        manager.showsBackgroundLocationIndicator = true
    }
    
    func requestLocation() -> Bool {
        return checkCurrentLocationPermission()
    }
    
    func startTracking() {
        guard checkCurrentLocationPermission() else { return }
        
        guard !isTracking.value else { return }
        
        trackingCoordinates.accept([]) // 새로운 추적 시작 시 기존 좌표 초기화
        manager.startUpdatingLocation()
        isTracking.accept(true)
    }
    
    func stopTracking() {
        trackingCoordinates.accept([])
        manager.stopUpdatingLocation()
        isTracking.accept(false)
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
    
    private func checkCurrentLocationPermission() -> Bool {
        let status = manager.authorizationStatus
        
        switch status {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
            return false
        case .restricted:
            permissionAlert(
                title: "위치 권한 제한됨",
                message: "이 기기에서 위치 서비스 사용이 제한되어 있습니다. 기기의 '설정'에서 확인해주세요."
            )
            return false
        case .denied:
            permissionAlert(
                title: "위치 권한 거부됨",
                message: "위치 기반 서비스를 사용하기 위해 설정에서 위치 권한을 허용해주세요."
            )
            return false
        case .authorizedAlways:
            print("authorizedAlways")
            return true
        case .authorizedWhenInUse:
            print("authorizedWhenInUse")
            return true
        default:
            permissionAlert(
                title: "위치 권한 오류",
                message: "알 수 없는 위치 권한 상태입니다. 설정에서 위치 권한을 확인해주세요."
            )
            return false
        }
    }
    
    private func permissionAlert(title: String, message: String) {
        let scenes = UIApplication.shared.connectedScenes
        guard let windowScene = scenes.first as? UIWindowScene,
              let window = windowScene.windows.first
        else { return }
        
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        let settingsAction = UIAlertAction(title: "설정으로 이동", style: .default) { [weak self] _ in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL)
                self?.rootTBC()
            }
        }
        
        let cancelAction = UIAlertAction(title: C.cancelTitle, style: .cancel, handler: {[weak self] _ in
            self?.rootTBC()
        })
        
        alert.addAction(settingsAction)
        alert.addAction(cancelAction)
        alert.overrideUserInterfaceStyle = .light
        
        window.rootViewController?.dismiss(animated: true)
        window.rootViewController?.present(alert, animated: true)
    }
    
    private func rootTBC() {
        let scenes = UIApplication.shared.connectedScenes
        guard let windowScene = scenes.first as? UIWindowScene,
              let window = windowScene.windows.first
        else { return }
        
        //refactor 지금까지의 경로 UserDefaults 에 저장해놓고 root 전환 + toast, 푸시 알림
        stopTracking()
        window.rootViewController = TabBarController()
    }
    
}
