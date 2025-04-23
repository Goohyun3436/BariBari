//
//  IconView.swift
//  BariBari
//
//  Created by Goo on 4/22/25.
//

import UIKit

final class IconView: UIImageView {
    
    init(_ icon: AppIcon? = nil, color: AppColor = .black) {
        super.init(frame: .zero)
        if let icon {
            image = UIImage(systemName: icon.value)
        }
        tintColor = color.value
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
