//
//  LocationView.swift
//  BariBari
//
//  Created by Goo on 4/5/25.
//

import UIKit
import SnapKit

final class LocationView: BaseView {
    
    // MARK: - UI Property
    private let subWrap = UIStackView()
    private let iconView = UIImageView()
    let label = AppLabel(.text3, .darkGray)
    
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
        subWrap.spacing = spacing
        
        iconView.snp.makeConstraints { make in
            make.size.equalTo(iconSize)
        }
    }
    
    override func setupAttributes() {
        iconView.image = UIImage(systemName: AppIcon.pin.value)
        iconView.tintColor = AppColor.gray.value
    }
}
