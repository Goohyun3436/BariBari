//
//  OpenMapButtonView.swift
//  BariBari
//
//  Created by Goo on 4/9/25.
//

import UIKit
import SnapKit

enum OpenMapType {
    case naver
    
    var image: AppImage {
        switch self {
        case .naver:
            return .naverMap
        }
    }
    
    var title: String {
        switch self {
        case .naver:
            return C.naverMapTitle
        }
    }
}

final class OpenMapButtonView: BaseView {
    
    //MARK: - UI Property
    private let wrap = UIStackView()
    lazy var button = ImageButton(image: type.image, borderColor: .border)
    private lazy var label = AppLabel(.text3)
    
    //MARK: - Property
    private let type: OpenMapType
    
    //MARK: - Initializer Method
    init(type: OpenMapType) {
        self.type = type
        super.init(frame: .zero)
    }
    
    //MARK: - Setup Method
    override func setupUI() {
        [button, label].forEach {
            wrap.addArrangedSubview($0)
        }
        
        addSubview(wrap)
    }
    
    override func setupConstraints() {
        let buttonSize: CGFloat = 50
        let marginV: CGFloat = 8
        
        wrap.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        wrap.axis = .vertical
        wrap.alignment = .center
        wrap.spacing = marginV
        
        button.snp.makeConstraints { make in
            make.size.equalTo(buttonSize)
        }
    }
    
    override func setupAttributes() {
        label.text = type.title
    }
    
}
