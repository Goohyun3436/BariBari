//
//  IconButton.swift
//  BariBari
//
//  Created by Goo on 4/7/25.
//

import UIKit

class IconButton: UIButton {
    
    init(
        icon: AppIcon,
        selectedIcon: AppIcon? = nil,
        color: AppColor = .black
    ) {
        super.init(frame: .zero)
        setImage(UIImage(
            systemName: icon.value,
            withConfiguration: UIImage.SymbolConfiguration(
                font: AppFont.largeIcon.value
            )
        ), for: .normal)
        if let selectedIcon {
            setImage(UIImage(
                systemName: selectedIcon.value,
                withConfiguration: UIImage.SymbolConfiguration(
                    font: AppFont.largeIcon.value
                )
            ), for: .selected)
        }
        tintColor = color.value
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
