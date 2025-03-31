//
//  TestViewController.swift
//  BariBari
//
//  Created by Goo on 3/31/25.
//

import UIKit
import CoreLocation
import MapKit
import RxSwift
import RxCocoa
import Rx
import RxMKMapView
import SnapKit

class MyMapAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    
    init(coord: Coord, title: String? = nil) {
        self.title = title
        self.coordinate = CLLocationCoordinate2D(
            latitude: coord.lat,
            longitude: coord.lng
        )
        super.init()
    }
}

class TestViewController: UIViewController {
    
    let mapView = MKMapView()
    let startButton = UIButton()
    let endButton = UIButton()
    let statusLabel = UILabel()
    
    let locationManager = CLLocationManager()
    
    let locationSubject = PublishSubject<[CLLocation]>()
    var trackingCoordinates = BehaviorRelay<[CLLocationCoordinate2D]>(value: [])
    var isTracking = BehaviorRelay<Bool>(value: false)
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: - UI
        view.addSubview(mapView)
        view.addSubview(startButton)
        view.addSubview(endButton)
        view.addSubview(statusLabel)
        
        mapView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(500)
        }
        
        startButton.snp.makeConstraints { make in
            make.top.equalTo(mapView.snp.bottom)
            make.leading.equalToSuperview()
            make.size.equalTo(50)
        }
        
        endButton.snp.makeConstraints { make in
            make.top.equalTo(mapView.snp.bottom)
            make.trailing.equalToSuperview()
            make.size.equalTo(50)
        }
        
        statusLabel.snp.makeConstraints { make in
            make.top.equalTo(endButton.snp.bottom)
            make.horizontalEdges.equalToSuperview()
        }
        
        startButton.backgroundColor = .red
        endButton.backgroundColor = .green
        
        
        //MARK: - locationManager
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.activityType = .automotiveNavigation // 오토바이 주행에 적합
        locationManager.distanceFilter = 10 // 10미터마다 위치 업데이트
        
        mapView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        requestForAnnotations()
            .asDriver(onErrorJustReturn: [])
            .drive(mapView.rx.annotations)
            .disposed(by: disposeBag)
        
        startButton.rx.tap
            .bind(with: self, onNext: { owner, _ in
                owner.isTracking.accept(true)
                owner.trackingCoordinates.accept([]) // 새로운 추적 시작 시 기존 좌표 초기화
                owner.locationManager.startUpdatingLocation()
                
                // 지도에서 기존 오버레이 및 어노테이션 제거
                owner.mapView.removeOverlays(self.mapView.overlays)
                owner.mapView.removeAnnotations(self.mapView.annotations.filter { !($0 is MKUserLocation) })
            })
            .disposed(by: disposeBag)
        
        endButton.rx.tap
            .bind(with: self, onNext: { owner, _ in
                owner.isTracking.accept(false)
                owner.locationManager.stopUpdatingLocation()
                owner.drawCompletedRoute()
            })
            .disposed(by: disposeBag)
        
//         RxCoreLocation을 사용한 위치 업데이트 바인딩
        locationManager.rx.didUpdateLocations
            .withLatestFrom(isTracking) { (locations, isTracking) -> (locations: [CLLocation], isTracking: Bool) in
                return (locations: locations, isTracking: isTracking)
            }
            .filter { $0.isTracking }
            .map { $0.locations }
            .bind(with: self, onNext: { owner, locations in
                guard let location = locations.last else { return }
                
                // 새 위치를 추적 좌표에 추가
                var currentCoordinates = owner.trackingCoordinates.value
                currentCoordinates.append(location.coordinate)
                owner.trackingCoordinates.accept(currentCoordinates)
                
                // 지도 중심 업데이트
                let region = MKCoordinateRegion(
                    center: location.coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
                )
                owner.mapView.setRegion(region, animated: true)
                
                // 상태 업데이트
                owner.updateStatus(with: location)
                
                // 지도에 점 추가
                owner.addPointAnnotation(at: location.coordinate)
                
                // 이전 위치와 현재 위치 사이에 선 그리기
                if currentCoordinates.count > 1 {
                    owner.drawLineBetweenPoints(
                        from: currentCoordinates[currentCoordinates.count - 2],
                        to: currentCoordinates[currentCoordinates.count - 1]
                    )
                }
            })
            .disposed(by: disposeBag)
        
        // 위치 권한 상태 변경 감지
        locationManager.rx.didChangeAuthorization
            .subscribe(onNext: { [weak self] manager, status in
                switch status {
                case .authorizedWhenInUse, .authorizedAlways:
                    self?.statusLabel.text = "위치 권한 승인됨"
                case .denied, .restricted:
                    self?.statusLabel.text = "위치 권한이 필요합니다"
                case .notDetermined:
                    self?.statusLabel.text = "위치 권한을 요청합니다"
                @unknown default:
                    self?.statusLabel.text = "알 수 없는 권한 상태"
                }
            })
            .disposed(by: disposeBag)
        
        // 위치 오류 처리
        locationManager.rx.didFail
            .subscribe(onNext: { [weak self] _, error in
                self?.statusLabel.text = "위치 오류: \(error.localizedDescription)"
            })
            .disposed(by: disposeBag)
        
        // 추적 상태에 따른 UI 업데이트
        isTracking
            .subscribe(onNext: { [weak self] isTracking in
                self?.startTrackingButton.isEnabled = !isTracking
                self?.stopTrackingButton.isEnabled = isTracking
                self?.statusLabel.text = isTracking ? "오토바이 추적 중..." : "추적 중지됨"
            })
            .disposed(by: disposeBag)
    }
    
    func requestForAnnotations() -> Observable<[MyMapAnnotation]> {
        return Observable.create { observer in
            let annotations = [
                MyMapAnnotation(coord: Coord(lat: 37.5665, lng: 126.9780), title: "서울"),
                MyMapAnnotation(coord: Coord(lat: 35.1796, lng: 129.0756), title: "부산"),
                MyMapAnnotation(coord: Coord(lat: 37.4563, lng: 126.7052), title: "인천"),
                MyMapAnnotation(coord: Coord(lat: 35.8714, lng: 128.6014), title: "대구")
            ]
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                observer.onNext(annotations)
                observer.onCompleted()
            }
            
            return Disposables.create()
        }
    }
    
    private func drawLineBetweenPoints(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) {
        let coordinates = [from, to]
        let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
        mapView.addOverlay(polyline)
    }
    
    private func drawCompletedRoute() {
        let coordinates = trackingCoordinates.value
        if coordinates.count > 1 {
            let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
            mapView.addOverlay(polyline)
            
            // 전체 경로가 보이도록 지도 영역 조정
            mapView.setVisibleMapRect(polyline.boundingMapRect, edgePadding: UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50), animated: true)
        }
    }
    
    private func updateStatus(with location: CLLocation) {
        let speed = location.speed > 0 ? location.speed : 0
        let speedKmh = speed * 3.6 // m/s를 km/h로 변환
        statusLabel.text = String(format: "속도: %.1f km/h", speedKmh)
    }
    
}

extension TestViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.strokeColor = .systemBlue
            renderer.lineWidth = 4
            return renderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil // 사용자 위치는 기본 파란색 점으로 표시
        }
        
        let identifier = "MotorcycleTrackPoint"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            (annotationView as? MKMarkerAnnotationView)?.markerTintColor = .red
            annotationView?.displayPriority = .required
            annotationView?.canShowCallout = false
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
}
