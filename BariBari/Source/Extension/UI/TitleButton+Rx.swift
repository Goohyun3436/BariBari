//
//  UIButton+Rx.swift
//  BariBari
//
//  Created by Goo on 4/4/25.
//

import UIKit
import RxSwift

extension Reactive where Base: UIButton {
    
    func configTitle() -> Binder<String> {
        return Binder(self.base) { button, title in
            guard var config = button.configuration else { return }
            
            var attributedTitle = AttributedString(title)
            
            if let existing = config.attributedTitle {
                
                attributedTitle.font = (button as? TitleButton)?.currentFont
                
                if let color = existing.foregroundColor {
                    attributedTitle.foregroundColor = color
                }
            }
            
            config.attributedTitle = attributedTitle
            button.configuration = config
        }
    }
    
    func configForegroundColor() -> Binder<AppColor> {
        return Binder(self.base) { button, color in
            guard var config = button.configuration else { return }
            
            guard var attributedTitle = config.attributedTitle else { return }
            
            attributedTitle.foregroundColor = color.value
            attributedTitle.font = (button as? TitleButton)?.currentFont
            config.attributedTitle = attributedTitle
            button.configuration = config
        }
    }
    
}
