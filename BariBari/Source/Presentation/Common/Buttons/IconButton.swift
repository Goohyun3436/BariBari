//
//  IconButton.swift
//  BariBari
//
//  Created by Goo on 4/7/25.
//

import UIKit

final class IconButton: UIButton {
    
    init(_ icon: AppIcon, _ color: AppColor = .black) {
        super.init(frame: .zero)
        setImage(UIImage(
            systemName: icon.value,
            withConfiguration: UIImage.SymbolConfiguration(
                font: AppFont.largeIcon.value
            )
        ), for: .normal)
        tintColor = color.value
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
