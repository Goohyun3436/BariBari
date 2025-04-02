//
//  CreateView.swift
//  BariBari
//
//  Created by Goo on 4/2/25.
//

import UIKit
import SnapKit

final class CreateView: BaseView {
    
    //MARK: - UI Property
    private let wrap = UIStackView()
    let trackingCard = CreateInfoCardView(.tracking)
    let autoCard = CreateInfoCardView(.auto)
    
    //MARK: - Setup Method
    override func setupUI() {
        [trackingCard, autoCard].forEach {
            wrap.addArrangedSubview($0)
        }
        
        addSubview(wrap)
    }
    
    override func setupConstraints() {
        let margin: CGFloat = 16
        
        wrap.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide).inset(margin)
        }
        wrap.axis = .vertical
        wrap.spacing = margin
        wrap.distribution = .fillEqually
    }
    
    override func setupAttributes() {
        backgroundColor = AppColor.lightGray.value
    }
    
}
