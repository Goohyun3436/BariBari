//
//  MapPickerView.swift
//  BariBari
//
//  Created by Goo on 4/5/25.
//

import UIKit
import SnapKit

final class MapPickerView: BaseView {  //refactor: 카카오맵, 티맵 추가
    
    //MARK: - UI Property
    private let buttonsWrap = UIStackView()
    private let buttonWrap = UIStackView()
    let naverMapButton = UIButton()
    private let naverMapLabel = AppLabel(.text3)
    
    //MARK: - Setup Method
    override func setupUI() {
        [naverMapButton, naverMapLabel].forEach {
            buttonWrap.addArrangedSubview($0)
        }
        
        buttonsWrap.addArrangedSubview(buttonWrap)
        addSubview(buttonsWrap)
    }
    
    override func setupConstraints() {
        let marginV: CGFloat = 24
        let marginH: CGFloat = 16
        let buttonSize: CGFloat = 50
        let buttonMargin: CGFloat = 8
        
        buttonsWrap.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(marginV)
//            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(marginH)
            make.centerX.equalTo(safeAreaLayoutGuide)
            make.bottom.lessThanOrEqualToSuperview().offset(-marginV)
        }
        buttonsWrap.axis = .horizontal
//        buttonsWrap.distribution = .equalSpacing
        
        buttonWrap.snp.makeConstraints { make in
            make.width.equalTo(buttonSize + marginH)
        }
        buttonWrap.axis = .vertical
        buttonWrap.alignment = .center
        buttonWrap.spacing = buttonMargin
        
        naverMapButton.snp.makeConstraints { make in
            make.size.equalTo(buttonSize)
        }
    }
    
    override func setupAttributes() {
        naverMapButton.clipsToBounds = true
        naverMapButton.layer.cornerRadius = 16
        naverMapButton.layer.borderWidth = 1
        naverMapButton.layer.borderColor = AppColor.border.value.cgColor
        naverMapButton.setImage(UIImage(named: AppImage.naverMap.value), for: .normal)
        naverMapLabel.text = C.naverMapTitle
    }
    
}
