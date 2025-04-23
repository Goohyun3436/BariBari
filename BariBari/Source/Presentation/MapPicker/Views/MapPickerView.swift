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
    let naverMap = OpenMapButtonView(type: .naver)
    
    //MARK: - Setup Method
    override func setupUI() {
        [naverMap].forEach {
            buttonsWrap.addArrangedSubview($0)
        }
        
        addSubview(buttonsWrap)
    }
    
    override func setupConstraints() {
        let insetV: CGFloat = 24
        
        buttonsWrap.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(insetV)
            make.centerX.equalTo(safeAreaLayoutGuide)
            make.bottom.lessThanOrEqualToSuperview().offset(-0)
        }
        buttonsWrap.axis = .horizontal
//        buttonsWrap.distribution = .equalSpacing
    }
    
}
