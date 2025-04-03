//
//  CreateTrackingView.swift
//  BariBari
//
//  Created by Goo on 4/2/25.
//

import UIKit
import SnapKit

enum CreateTrackingStatus {
    case ready
    case tracking
    case complete
}

final class CreateTrackingView: BaseView {
    
    //MARK: - UI Property
    let mapView = CustomMapView()
    private let wrap = UIStackView()
    let startButton = TrackingStartButton()
    let trackingBar = BottomBar()
    
    deinit {
        print(self, #function)
    }
    
    //MARK: - Setup Method
    func setTrackingStatus(_ status: CreateTrackingStatus) {
        switch status {
        case .ready:
            trackingBar.alpha = 0
            startButton.isHidden = false
            trackingBar.isHidden = true
            UIView.animate(withDuration: 0.3) {
                self.startButton.alpha = 1
            }
        case .tracking:
            startButton.alpha = 0
            startButton.isHidden = true
            trackingBar.isHidden = false
            UIView.animate(withDuration: 0.3) {
                self.trackingBar.alpha = 1
            }
        case .complete:
            startButton.alpha = 0
            trackingBar.alpha = 0
            startButton.isHidden = false
            trackingBar.isHidden = true
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
