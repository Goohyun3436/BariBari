//
//  EditButton.swift
//  BariBari
//
//  Created by Goo on 4/6/25.
//

import UIKit

final class EditButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setImage(UIImage(
            systemName: AppIcon.edit.value,
            withConfiguration: UIImage.SymbolConfiguration(
                font: AppFont.largeIcon.value
            )
        ), for: .normal)
        setImage(UIImage(
            systemName: AppIcon.check.value,
            withConfiguration: UIImage.SymbolConfiguration(
                font: AppFont.largeIcon.value
            )
        ), for: .selected)
        tintColor = AppColor.black.value
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
