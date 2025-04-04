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
    let menuButton = UIButton()
    
    //MARK: - Setup Method
    override func setupUI() {
        [titleLabel, distanceLabel, menuButton].forEach {
            wrap.contentView.addSubview($0)
        }
        
        addSubview(wrap)
    }
    
    override func setupConstraints() {
        let bottomBarPadding: CGFloat = 16
        let menuButtonSize: CGFloat = 30
        
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
            make.trailing.lessThanOrEqualTo(menuButton.snp.leading).offset(-bottomBarPadding)
            make.bottom.equalToSuperview().inset(bottomBarPadding)
        }
        
        menuButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(bottomBarPadding)
            make.size.equalTo(menuButtonSize)
        }
    }
    
    override func setupAttributes() {
        backgroundColor = AppColor.clear.value
        menuButton.setImage(UIImage(systemName: AppIcon.menu.value), for: .normal)
        menuButton.tintColor = AppColor.black.value
    }
}
