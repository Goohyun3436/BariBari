//
//  FloatingButton.swift
//  BariBari
//
//  Created by Goo on 4/2/25.
//

import UIKit

final class FloatingButton: TitleButton {
    
    override init(
        title: String = "",
        font: AppFont = .title1,
        color: AppColor = .black,
        bgColor: AppColor = .white,
        borderColor: AppColor? = nil
    ) {
        super.init(
            title: title,
            font: font,
            color: color,
            bgColor: bgColor,
            borderColor: borderColor
        )
        clipsToBounds = false
        layer.masksToBounds = false
        layer.shadowColor = AppColor.black.value.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 8
        layer.shadowOpacity = 0.2
    }
    
}
