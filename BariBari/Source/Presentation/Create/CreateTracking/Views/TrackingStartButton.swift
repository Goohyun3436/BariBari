//
//  TrackingStartButton.swift
//  BariBari
//
//  Created by Goo on 4/2/25.
//

import UIKit

final class TrackingStartButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 8
        layer.shadowColor = AppColor.black.value.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 8
        layer.shadowOpacity = 0.2
        clipsToBounds = false
        layer.masksToBounds = false
        backgroundColor = AppColor.blue.value
        setTitle(C.trackingStartButtonTitle, for: .normal)
        titleLabel?.font = AppFont.title1.value
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
