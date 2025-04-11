//
//  ModalButton.swift
//  BariBari
//
//  Created by Goo on 4/10/25.
//

import UIKit

class ModalButton: TitleButton {
    
    init(title: String = "") {
        super.init(
            title: title,
            font: .title2,
            color: .black,
            bgColor: .clear,
            borderColor: nil
        )
        layer.cornerRadius = 0
    }
    
    override func draw(_ rect: CGRect) {
        let borderTop = UIView(frame: CGRectMake(0, 0, rect.size.width, 0.5))
        borderTop.backgroundColor = AppColor.border.value
        addSubview(borderTop)
    }
    
}
