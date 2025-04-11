//
//  ImageButton.swift
//  BariBari
//
//  Created by Goo on 4/9/25.
//

import UIKit

class ImageButton: UIButton {
    
    init(
        image: AppImage,
        borderColor: AppColor? = nil
    ) {
        super.init(frame: .zero)
        clipsToBounds = true
        layer.cornerRadius = 16
        layer.borderWidth = 1
        if let borderColor {
            layer.borderColor = borderColor.value.cgColor
        }
        setImage(UIImage(named: image.value), for: .normal)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
