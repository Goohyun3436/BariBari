//
//  TestViewController.swift
//  BariBari
//
//  Created by Goo on 3/31/25.
//

import UIKit
import MapKit
import RxSwift
import RxCocoa
import SnapKit

class TestViewController: UIViewController {
    
    let mapView = CustomMapView()
    let startButton = UIButton()
    let stopButton = UIButton()
    let statusLabel = UILabel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        mapView.delegate = self
        LocationManager.shared.trigger()
        
        requestForAnnotations()
            .asDriver(onErrorJustReturn: [])
            .drive(mapView.rx.annotations)
            .disposed(by: disposeBag)
        
        startButton.rx.tap
            .debug("startButton")
            .bind(with: self, onNext: { owner, _ in
                LocationManager.shared.startTracking()
                owner.mapView.clearRoute()
            })
            .disposed(by: disposeBag)
        
        stopButton.rx.tap
            .debug("stopButton")
            .bind(with: self, onNext: { owner, _ in
                LocationManager.shared.stopTracking()
                owner.mapView.drawCompletedRoute()
            })
            .disposed(by: disposeBag)
        
        LocationManager.shared.observeLocationUpdates()
            .bind(with: self, onNext: { owner, locations in
                guard let location = locations.last else { return }
                print(locations)
                
                // 지도 중심 업데이트
                owner.mapView.updateRegion(to: location.coordinate)
                
                // 상태 업데이트
                owner.updateStatus(with: location)
                
                // 지도에 점 추가
                owner.mapView.addPoint(at: location.coordinate)
                
                // 이전 위치와 현재 위치 사이에 선 그리기
                owner.mapView.drawLineBetween()
            })
            .disposed(by: disposeBag)
        
        LocationManager.shared.isTracking
            .bind(with: self, onNext: { owner, isTracking in
                owner.startButton.isEnabled = !isTracking
                owner.stopButton.isEnabled = isTracking
                owner.statusLabel.text = isTracking ? "오토바이 추적 중..." : "추적 중지됨"
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
    
    private func updateStatus(with location: CLLocation) {
        let speed = location.speed > 0 ? location.speed : 0
        let speedKmh = speed * 3.6 // m/s를 km/h로 변환
        statusLabel.text = String(format: "속도: %.1f km/h", speedKmh)
    }
    
    private func setupUI() {
        view.addSubview(mapView)
        view.addSubview(startButton)
        view.addSubview(stopButton)
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
        
        stopButton.snp.makeConstraints { make in
            make.top.equalTo(mapView.snp.bottom)
            make.trailing.equalToSuperview()
            make.size.equalTo(50)
        }
        
        statusLabel.snp.makeConstraints { make in
            make.top.equalTo(stopButton.snp.bottom)
            make.horizontalEdges.equalToSuperview()
        }
        
        startButton.backgroundColor = .red
        stopButton.backgroundColor = .green
    }
    
}

// MARK: - MKMapViewDelegate
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
        if annotation is MKUserLocation { return nil } // 사용자 위치는 기본 파란색 점으로 표시
        
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
