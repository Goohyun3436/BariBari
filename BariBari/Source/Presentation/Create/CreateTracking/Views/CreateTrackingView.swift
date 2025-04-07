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
    private let buttonWrap = UIStackView()
    let quitButton = FloatingButton(
        title: C.quitTitle,
        color: .white,
        bg: .gray
    )
    let startButton = FloatingButton(
        title: C.trackingStartButtonTitle,
        color: .white,
        bg: .blue
    )
    let trackingBar = BottomBar()
    
    //MARK: - Setup Method
    func setTrackingStatus(_ status: CreateTrackingStatus) {
        switch status {
        case .ready:
            trackingBar.alpha = 0
            buttonWrap.isHidden = false
            trackingBar.isHidden = true
            UIView.animate(withDuration: 0.3) {
                self.startButton.alpha = 1
            }
        case .tracking:
            buttonWrap.alpha = 0
            buttonWrap.isHidden = true
            trackingBar.isHidden = false
            UIView.animate(withDuration: 0.3) {
                self.trackingBar.alpha = 1
            }
        case .complete:
            buttonWrap.alpha = 0
            trackingBar.alpha = 0
            buttonWrap.isHidden = false
            trackingBar.isHidden = true
        }
    }
    
    override func setupUI() {
        [quitButton, startButton].forEach {
            buttonWrap.addArrangedSubview($0)
        }
        
        [buttonWrap, trackingBar].forEach {
            wrap.addArrangedSubview($0)
        }
        
        [mapView, wrap].forEach {
            addSubview($0)
        }
    }
    
    override func setupConstraints() {
        let margin: CGFloat = 16
        let bottomMargin: CGFloat = 32
        let quitButtonW: CGFloat = 100
        let buttonH: CGFloat = 50
        
        mapView.snp.makeConstraints { make in
            make.size.equalToSuperview()
        }
        
        wrap.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(margin)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(bottomMargin)
        }
        wrap.axis = .vertical
        
        buttonWrap.snp.makeConstraints { make in
            make.height.equalTo(buttonH)
        }
        buttonWrap.axis = .horizontal
        buttonWrap.distribution = .fillProportionally
        buttonWrap.spacing = margin / 2
        
        quitButton.snp.makeConstraints { make in
            make.width.equalTo(quitButtonW)
        }
    }
    
}
