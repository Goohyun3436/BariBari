//
//  CustomMapView.swift
//  BariBari
//
//  Created by Goo on 4/1/25.
//

import UIKit
import MapKit
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
    
    private var routeOverlays: [MKOverlay] = []
    private var routeAnnotations: [MKAnnotation] = []
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        showsUserLocation = true
        showsCompass = true
        showsScale = true
    }
    
    func updateRegion(to coordinate: CLLocationCoordinate2D, delta: Double = 0.005) {
        let region = MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: delta, longitudeDelta: delta)
        )
        setRegion(region, animated: true)
    }
    
    func addPoint(at coordinate: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        addAnnotation(annotation)
        routeAnnotations.append(annotation)
    }
    
    func drawLineBetween() {
        let coordinates = LocationManager.shared.trackingCoordinates.value
        if coordinates.count > 1 {
            let from = coordinates[coordinates.count - 2]
            let to = coordinates[coordinates.count - 1]
            let coordinates = [from, to]
            let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
            addOverlay(polyline)
            routeOverlays.append(polyline)
        }
    }
    
    func drawCompletedRoute() {
        let coordinates = LocationManager.shared.trackingCoordinates.value
        if coordinates.count > 1 {
            let polyline = MKPolyline(
                coordinates: coordinates,
                count: coordinates.count
            )
            addOverlay(polyline)
            routeOverlays.append(polyline)
            
            // 전체 경로가 보이도록 지도 영역 조정
            setVisibleMapRect(
                polyline.boundingMapRect,
                edgePadding: UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50),
                animated: true
            )
        }
    }
    
    func clearRoute() {
        removeOverlays(routeOverlays)
        removeAnnotations(routeAnnotations)
        routeOverlays.removeAll()
        routeAnnotations.removeAll()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
