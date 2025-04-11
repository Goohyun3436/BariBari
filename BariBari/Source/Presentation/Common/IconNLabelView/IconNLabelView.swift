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
    private let wrap = UIStackView()
    private let iconView = UIImageView()
    let label = AppLabel(.text3, .darkGray)
    
    //MARK: - Initializer Method
    init(_ icon: AppIcon, _ color: AppColor = .darkGray) {
        super.init(frame: .zero)
        iconView.image = UIImage(
            systemName: icon.value,
            withConfiguration: UIImage.SymbolConfiguration(
                font: AppFont.subText3.value
            )
        )
        iconView.tintColor = color.value
        label.textColor = color.value
    }
    
    //MARK: - Setup Method
    override func setupUI() {
        [iconView, label].forEach {
            wrap.addArrangedSubview($0)
        }
        
        addSubview(wrap)
    }
    
    override func setupConstraints() {
        let spacing: CGFloat = 4
        
        wrap.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        wrap.axis = .horizontal
        wrap.alignment = .center
        wrap.spacing = spacing
    }
    
    override func setupAttributes() {
        backgroundColor = AppColor.clear.value
        iconView.tintColor = AppColor.gray.value
    }
}
