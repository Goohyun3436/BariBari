//
//  CustomMapView.swift
//  BariBari
//
//  Created by Goo on 4/1/25.
//

import UIKit
import MapKit
import RxSwift
import RxMKMapView

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

final class CustomMapView: MKMapView {
    
    //MARK: - Property
    static let motorcycleTrackPointId = "motorcycleTrackPointId"
    
    private var routeOverlays: [MKOverlay] = []
    private var routeAnnotations: [MKAnnotation] = []
    private let isUserInteractingSubject = BehaviorSubject<Bool>(value: false)
    
    var isUserInteracting: Observable<Bool> {
        return isUserInteractingSubject.asObservable()
    }
    
    //MARK: - Initializer Method
    override init(frame: CGRect) {
        super.init(frame: .zero)
        delegate = self
        showsUserLocation = true
        showsCompass = true
        showsScale = true
    }
    
    //MARK: - Method
    func updateRegion(to coordinate: CLLocationCoordinate2D, delta: Double = 0.005) {
        let region = MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: delta, longitudeDelta: delta)
        )
        setRegion(region, animated: true)
    }
    
    func addPoint(at coordinate: CLLocationCoordinate2D, withAnnotation: Bool = false) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        routeAnnotations.append(annotation)
        if withAnnotation { addAnnotation(annotation) }
    }
    
    func drawLineBetween(_ from: CLLocationCoordinate2D, _ to: CLLocationCoordinate2D) {
        let coordinates = [from, to]
        let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
        addOverlay(polyline)
        routeOverlays.append(polyline)
    }
    
    func drawCompletedRoute(with coordinates: [CLLocationCoordinate2D], focusTop: Bool = false) {
        if coordinates.count > 1 {
            let polyline = MKPolyline(
                coordinates: coordinates,
                count: coordinates.count
            )
            addOverlay(polyline)
            routeOverlays.append(polyline)
            
            if let from = coordinates.first {
                addPoint(at: from, withAnnotation: true)
            }
            
            if let to = coordinates.last {
                addPoint(at: to, withAnnotation: true)
            }
            
            // 전체 경로가 보이도록 지도 영역 조정
            let mapRect = polyline.boundingMapRect
            let mapHeight = self.frame.height
            let padding: CGFloat = 50
            let bottomPadding = mapHeight / 2 + padding
            
            setVisibleMapRect(
                mapRect,
                edgePadding: UIEdgeInsets(
                    top: padding,
                    left: padding,
                    bottom: focusTop ? bottomPadding : padding,
                    right: padding
                ),
                animated: true
            )
        }
    }
    
    //    func drawDirectionRoute(with coordinates: [CLLocationCoordinate2D]) {
    //        guard coordinates.count >= 2 else { return }
    //
    //        var routeCoordinates: [CLLocationCoordinate2D] = []
    //
    //        let group = DispatchGroup()
    //
    //        for i in 0..<(coordinates.count - 1) {
    //            let from = MKMapItem(placemark: MKPlacemark(coordinate: coordinates[i]))
    //            let to = MKMapItem(placemark: MKPlacemark(coordinate: coordinates[i + 1]))
    //
    //            let request = MKDirections.Request()
    //            request.source = from
    //            request.destination = to
    //            request.transportType = .automobile
    //
    //            group.enter()
    //
    //            let directions = MKDirections(request: request)
    //            directions.calculate { response, error in
    //                defer { group.leave() }
    //
    //                guard let route = response?.routes.first else { return } //refactor error 처리
    //
    //                let polyline = route.polyline
    //                var coords = [CLLocationCoordinate2D](repeating: kCLLocationCoordinate2DInvalid, count: polyline.pointCount)
    //                polyline.getCoordinates(&coords, range: NSRange(location: 0, length: polyline.pointCount))
    //                routeCoordinates.append(contentsOf: coords)
    //            }
    //        }
    //
    ////        group.notify(queue: .main) { [weak self] in
    ////            self?.drawCompletedRoute(with: routeCoordinates)
    ////        }
    //    }
    
    func clearRoute() {
        removeOverlays(routeOverlays)
        removeAnnotations(routeAnnotations)
        routeOverlays.removeAll()
        routeAnnotations.removeAll()
    }
    
    private func checkUserGestureState() -> Bool {
        guard let gestureRecognizers = subviews.first?.gestureRecognizers else {
            return false
        }
        
        return gestureRecognizers.contains { $0.state == .began || $0.state == .changed }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - MKMapViewDelegate
extension CustomMapView: MKMapViewDelegate {
    
    //MARK: - Overlay & Annotation
    func mapView(
        _ mapView: MKMapView,
        rendererFor overlay: MKOverlay
    ) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.strokeColor = AppColor.red.value
            renderer.lineWidth = 4
            return renderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }
    
    func mapView(
        _ mapView: MKMapView,
        viewFor annotation: MKAnnotation
    ) -> MKAnnotationView? {
        if annotation is MKUserLocation { return nil }
        
        let identifier = CustomMapView.motorcycleTrackPointId
        var annotationView = self.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            (annotationView as? MKMarkerAnnotationView)?.markerTintColor = AppColor.black.value
            annotationView?.displayPriority = .required
            annotationView?.canShowCallout = false
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
    
    //MARK: - UserInteraction
    func mapView(
        _ mapView: MKMapView,
        regionWillChangeAnimated animated: Bool
    ) {
        if checkUserGestureState() {
            isUserInteractingSubject.onNext(true)
        }
    }
    
    func mapView(
        _ mapView: MKMapView,
        regionDidChangeAnimated animated: Bool
    ) {
        isUserInteractingSubject.onNext(false)
    }
    
}
