//
//  TrackingModalView.swift
//  BariBari
//
//  Created by Goo on 4/2/25.
//

import UIKit
import SnapKit

final class TrackingModalView: BaseView {
    
    //MARK: - UI Property
    private let wrap = UIStackView()
    let quitButton = UIButton()
    let stopButton = UIButton()
    
    //MARK: - Setup Method
    override func setupUI() {
        [quitButton, stopButton].forEach {
            wrap.addArrangedSubview($0)
        }
        
        addSubview(wrap)
    }
    
    override func setupConstraints() {
        let margin: CGFloat = 16
        let buttonH: CGFloat = 50
        
        wrap.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview().inset(margin)
            make.height.equalTo(buttonH)
        }
        wrap.axis = .horizontal
        wrap.distribution = .fillEqually
        wrap.spacing = margin / 2
    }
    
    override func setupAttributes() {
        quitButton.setTitle(C.trackingQuitButtonTitle, for: .normal)
        quitButton.layer.cornerRadius = 8
        quitButton.backgroundColor = AppColor.gray.value
        quitButton.setTitleColor(AppColor.white.value, for: .normal)
        quitButton.titleLabel?.font = AppFont.title1.value
        stopButton.setTitle(C.trackingSaveButtonTitle, for: .normal)
        stopButton.layer.cornerRadius = 8
        stopButton.backgroundColor = AppColor.black.value
        stopButton.setTitleColor(AppColor.white.value, for: .normal)
        stopButton.titleLabel?.font = AppFont.title1.value
    }
    
}
