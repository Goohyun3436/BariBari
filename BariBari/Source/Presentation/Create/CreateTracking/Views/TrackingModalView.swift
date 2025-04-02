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
    let stopButton = UIButton()
    
    //MARK: - Setup Method
    override func setupUI() {
        [stopButton].forEach {
            addSubview($0)
        }
    }
    
    override func setupConstraints() {
        let inset: CGFloat = 16
        let buttonH: CGFloat = 50
        
        stopButton.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview().inset(inset)
            make.height.equalTo(buttonH)
        }
    }
    
    override func setupAttributes() {
        stopButton.setTitle(C.trackingStopButtonTitle, for: .normal)
        stopButton.layer.cornerRadius = 8
        stopButton.backgroundColor = AppColor.black.value
        stopButton.setTitleColor(AppColor.white.value, for: .normal)
        stopButton.titleLabel?.font = AppFont.title1.value
    }
    
}
