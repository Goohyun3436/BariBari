//
//  MapThumbnailView.swift
//  BariBari
//
//  Created by Goo on 4/5/25.
//

import UIKit
import MapKit
import SnapKit

final class MapThumbnailView: BaseView {
    
    // MARK: - UI Property
    private let topWrap = UIStackView()
    private let locationView = IconNLabelView(.pin)
    let mapButton = IconButton(icon: .map, size: .title1)
    private let mapView = CustomMapView()
    
    // MARK: - Setup Method
    func setData(_ address: String, _ pins: [Pin]) {
        locationView.label.text = address
        
        guard !pins.isEmpty else { return }
        
        mapView.clearRoute()
        
        let coordinates = pins.compactMap { $0.coord }.map {
            CLLocationCoordinate2D(latitude: $0.lat, longitude: $0.lng)
        }
        
//        mapView.drawDirectionRoute(with: coordinates)
        mapView.drawCompletedRoute(with: coordinates)
    }
    
    override func setupUI() {
        [locationView, mapButton].forEach {
            topWrap.addArrangedSubview($0)
        }
        
        [topWrap, mapView].forEach {
            addSubview($0)
        }
    }
    
    override func setupConstraints() {
        let marginV: CGFloat = 8
        let mapH: CGFloat = 300
        
        topWrap.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
        }
        topWrap.axis = .horizontal
        topWrap.distribution = .equalSpacing
        
        mapView.snp.makeConstraints { make in
            make.top.equalTo(topWrap.snp.bottom).offset(marginV)
            make.horizontalEdges.bottom.equalToSuperview()
            make.height.equalTo(mapH)
        }
    }
    
    override func setupAttributes() {
        mapView.clipsToBounds = true
        mapView.layer.cornerRadius = 8
    }
    
}
