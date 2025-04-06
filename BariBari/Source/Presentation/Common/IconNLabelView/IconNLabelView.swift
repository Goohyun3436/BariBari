//
//  IconNLabelView.swift
//  BariBari
//
//  Created by Goo on 4/5/25.
//

import UIKit
import SnapKit

final class IconNLabelView: BaseView {
    
    //MARK: - UI Property
    private let subWrap = UIStackView()
    private let iconView = UIImageView()
    let label = AppLabel(.text3, .darkGray)
    
    //MARK: - Initializer Method
    init(icon: AppIcon) {
        super.init(frame: .zero)
        iconView.image = UIImage(systemName: icon.value)
    }
    
    //MARK: - Setup Method
    override func setupUI() {
        [iconView, label].forEach {
            subWrap.addArrangedSubview($0)
        }
        
        addSubview(subWrap)
    }
    
    override func setupConstraints() {
        let spacing: CGFloat = 4
        let iconSize: CGFloat = 12
        
        subWrap.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        subWrap.axis = .horizontal
        subWrap.alignment = .center
        subWrap.spacing = spacing
        
        iconView.snp.makeConstraints { make in
            make.size.equalTo(iconSize)
        }
    }
    
    override func setupAttributes() {
        iconView.tintColor = AppColor.gray.value
    }
}
