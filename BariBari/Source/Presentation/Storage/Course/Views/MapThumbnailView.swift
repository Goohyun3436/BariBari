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
    private let locationView = IconNLabelView(icon: .pin)
    let mapButton = UIButton()
    private let mapView = CustomMapView()
    
    // MARK: - Setup Method
    func setData(_ address: String, _ pins: [Pin]) {
        locationView.label.text = address
        
        guard !pins.isEmpty else { return }
        
        mapView.clearRoute()
        
        let coordinates = pins.compactMap { $0.coord }.map {
            CLLocationCoordinate2D(latitude: $0.lat, longitude: $0.lng)
        }
        
        coordinates.forEach { coordinate in
            mapView.addPoint(at: coordinate)
        }
        
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
        let mapButtonSize: CGFloat = 30
        let mapH: CGFloat = 300
        
        topWrap.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
        }
        topWrap.axis = .horizontal
        topWrap.distribution = .equalSpacing
        
        mapButton.snp.makeConstraints { make in
            make.size.equalTo(mapButtonSize)
        }
        
        mapView.snp.makeConstraints { make in
            make.top.equalTo(topWrap.snp.bottom).offset(marginV)
            make.horizontalEdges.bottom.equalToSuperview()
            make.height.equalTo(mapH)
        }
    }
    
    override func setupAttributes() {
        mapButton.setImage(UIImage(systemName: AppIcon.map.value), for: .normal)
        mapButton.tintColor = AppColor.black.value
        mapView.clipsToBounds = true
        mapView.layer.cornerRadius = 8
    }
    
}
