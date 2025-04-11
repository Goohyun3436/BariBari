//
//  TitleButton.swift
//  BariBari
//
//  Created by Goo on 4/9/25.
//

import UIKit

class TitleButton: UIButton {
    
    private(set) var currentFont: UIFont?
    
    init(
        title: String = "",
        font: AppFont = .title2,
        color: AppColor = .black,
        bgColor: AppColor = .white,
        borderColor: AppColor? = nil
    ) {
        super.init(frame: .zero)
        
        clipsToBounds = true
        layer.cornerRadius = 8
        layer.borderWidth = 1
        if let borderColor {
            layer.borderColor = borderColor.value.cgColor
        } else {
            layer.borderColor = bgColor.value.cgColor
        }
        
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = bgColor.value
        config.baseForegroundColor = color.value
        
        var attributedTitle = AttributedString(title)
        attributedTitle.font = font.value
        currentFont = font.value
        config.attributedTitle = attributedTitle
        
        configuration = config
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
