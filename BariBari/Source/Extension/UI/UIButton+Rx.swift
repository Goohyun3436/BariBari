//
//  UIButton+Rx.swift
//  BariBari
//
//  Created by Goo on 4/4/25.
//

import UIKit
import RxSwift

extension Reactive where Base: UIButton {
    func configurationTitle() -> Binder<String> {
        return Binder(self.base) { button, title in
            guard var config = button.configuration else { return }
            
            var attributedTitle = AttributedString(title)
            if let existingAttributes = button.configuration?.attributedTitle {
                if let font = existingAttributes.font {
                    attributedTitle.font = font
                }
                
                if let foregroundColor = existingAttributes.foregroundColor {
                    attributedTitle.foregroundColor = foregroundColor
                }
            }
            
            config.attributedTitle = attributedTitle
            button.configuration = config
        }
    }
}
