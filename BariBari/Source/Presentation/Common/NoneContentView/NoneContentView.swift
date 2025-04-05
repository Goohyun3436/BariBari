//
//  NoneContentView.swift
//  BariBari
//
//  Created by Goo on 4/5/25.
//

import UIKit
import SnapKit

enum NoneContentType {
    case courseFolder
    case course
    
    var message: String {
        switch self {
        case .courseFolder:
            return "보관함이 비어있습니다.\n코스를 생성해보세요."
        case .course:
            return "폴더가 비어있습니다.\n코스를 생성해보세요."
        }
    }
}

final class NoneContentView: BaseView {
    
    // MARK: - UI Property
    private let messageLabel = AppLabel(.title4, .darkGray)
    
    //MARK: - Initializer Method
    init(_ type: NoneContentType) {
        super.init(frame: .zero)
        messageLabel.text = type.message
        messageLabel.setLineSpacing(4)
    }
    
    // MARK: - Setup Method
    override func setupUI() {
        addSubview(messageLabel)
    }
    
    override func setupConstraints() {
        messageLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    override func setupAttributes() {
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
    }
    
}
