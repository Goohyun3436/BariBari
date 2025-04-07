//
//  FloatingView.swift
//  BariBari
//
//  Created by Goo on 4/2/25.
//

import UIKit
import SnapKit

final class FloatingView: BaseView {
    
    let contentView = UIView()
    
    override func setupUI() {
        addSubview(contentView)
    }
    
    override func setupConstraints() {
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func setupAttributes() {
        layer.cornerRadius = 8
        layer.shadowColor = AppColor.black.value.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 8
        layer.shadowOpacity = 0.2
        clipsToBounds = false
        layer.masksToBounds = false
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true
    }
    
}
