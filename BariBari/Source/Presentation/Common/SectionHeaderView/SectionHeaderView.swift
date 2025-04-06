//
//  SectionHeaderView.swift
//  BariBari
//
//  Created by Goo on 4/7/25.
//

import UIKit
import SnapKit

final class SectionHeaderView: BaseView {
    
    //MARK: - UI Property
    let titleLabel = AppLabel(.title1)
    
    //MARK: - Setup Method
    override func setupUI() {
        addSubview(titleLabel)
    }
    
    override func setupConstraints() {
        let margin: CGFloat = 16
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(margin)
            make.trailing.lessThanOrEqualToSuperview().offset(-margin)
            make.centerY.equalToSuperview()
        }
    }
}
