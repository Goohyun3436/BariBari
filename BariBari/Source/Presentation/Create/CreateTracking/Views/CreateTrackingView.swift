//
//  CreateTrackingView.swift
//  BariBari
//
//  Created by Goo on 4/2/25.
//

import UIKit
import SnapKit

final class CreateTrackingView: BaseView {
    
    //MARK: - UI Property
    let mapView = CustomMapView()
    private let wrap = UIStackView()
    let startButton = TrackingStartButton()
    let trackingBar = BottomBar()
    
    //MARK: - Setup Method
    func setTrackingMode(_ isTracking: Bool) {
        if isTracking {
            startButton.alpha = 0
            startButton.isHidden = true
            trackingBar.isHidden = false
            UIView.animate(withDuration: 0.3) {
                self.trackingBar.alpha = 1
            }
        } else {
            trackingBar.alpha = 0
            startButton.isHidden = false
            trackingBar.isHidden = true
            UIView.animate(withDuration: 0.3) {
                self.startButton.alpha = 1
            }
        }
    }
    
    override func setupUI() {
        [startButton, trackingBar].forEach {
            wrap.addArrangedSubview($0)
        }
        
        [mapView, wrap].forEach {
            addSubview($0)
        }
    }
    
    override func setupConstraints() {
        let margin: CGFloat = 16
        let bottomMargin: CGFloat = 32
        let startButtonH: CGFloat = 44
        
        mapView.snp.makeConstraints { make in
            make.size.equalToSuperview()
        }
        
        wrap.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(margin)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(bottomMargin)
        }
        wrap.axis = .vertical
        
        startButton.snp.makeConstraints() { make in
            make.height.equalTo(startButtonH)
        }
    }
    
}
