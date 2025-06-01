//
//  TrackingModalView.swift
//  BariBari
//
//  Created by Goo on 4/2/25.
//

import UIKit
import SnapKit

final class TrackingModalView: BaseView {
    
    //MARK: - UI Property
    private let wrap = UIStackView()
    let quitButton = TitleButton(
        title: C.trackingQuitButtonTitle,
        font: .title1,
        color: .white,
        bgColor: .gray
    )
    let saveButton = TitleButton(
        title: C.trackingSaveButtonTitle,
        font: .title1,
        color: .white,
        bgColor: .black
    )
    
    //MARK: - Setup Method
    override func setupUI() {
        [quitButton, saveButton].forEach {
            wrap.addArrangedSubview($0)
        }
        
        addSubview(wrap)
    }
    
    override func setupConstraints() {
        let margin: CGFloat = 16
        let buttonH: CGFloat = 50
        
        wrap.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview().inset(margin)
            make.height.equalTo(buttonH)
        }
        wrap.axis = .horizontal
        wrap.distribution = .fillEqually
        wrap.spacing = margin / 2
    }
    
}
