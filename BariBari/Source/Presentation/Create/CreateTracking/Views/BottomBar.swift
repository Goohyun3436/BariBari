//
//  BottomBar.swift
//  BariBari
//
//  Created by Goo on 4/2/25.
//

import UIKit
import SnapKit

final class BottomBar: BaseView {
    
    //MARK: - UI Property
    private let wrap = FloatingView()
    let titleLabel = AppLabel(.text2)
    let distanceLabel = AppLabel(.title1)
    private let menuIcon = UIImageView()
    
    //MARK: - Setup Method
    override func setupUI() {
        [titleLabel, distanceLabel, menuIcon].forEach {
            wrap.contentView.addSubview($0)
        }
        
        addSubview(wrap)
    }
    
    override func setupConstraints() {
        let bottomBarPadding: CGFloat = 16
        let menuSize: CGFloat = 24
        
        wrap.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(bottomBarPadding)
            make.centerX.equalToSuperview()
        }
        
        distanceLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(bottomBarPadding / 2)
            make.centerX.equalToSuperview()
            make.leading.greaterThanOrEqualToSuperview().offset(bottomBarPadding)
            make.trailing.lessThanOrEqualTo(menuIcon.snp.leading).offset(-bottomBarPadding)
            make.bottom.equalToSuperview().inset(bottomBarPadding)
        }
        
        menuIcon.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(bottomBarPadding)
            make.size.equalTo(menuSize)
        }
    }
    
    override func setupAttributes() {
        backgroundColor = AppColor.clear.value
        menuIcon.contentMode = .scaleToFill
        menuIcon.image = UIImage(
            systemName: AppIcon.menu.value,
            withConfiguration: UIImage.SymbolConfiguration(
                font: AppFont.largeTitleRegular.value
            )
        )
        menuIcon.tintColor = AppColor.black.value
    }
}
