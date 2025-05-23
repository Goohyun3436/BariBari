//
//  CreateInfoCardView.swift
//  BariBari
//
//  Created by Goo on 4/2/25.
//

import UIKit
import SnapKit

enum CreateType {
    case tracking
    case auto
    
    var title: String {
        switch self {
        case .tracking:
            return "실시간 내 위치 추적하기"
        case .auto:
            return "수동으로 생성하기"
        }
    }
    
    var description: String {
        switch self {
        case .tracking:
            return "지도에서 실시간으로 내 위치를 추적하여 코스를 기록합니다."
        case .auto:
            return "지도에 수동으로 마커를 생성하여 코스를 기록합니다."
        }
    }
    
    var image: String {
        switch self {
        case .tracking:
            return AppImage.createTracking.value
        case .auto:
            return "star.fill" //refactor 교체
        }
    }
}

final class CreateInfoCardView: BaseView {
    
    // MARK: - UI Property
    private let titleLabel = AppLabel(.title2)
    private let descriptionLabel = AppLabel(.text2)
    private let imageView = UIImageView()
    private let dummyLabel = AppLabel(.text2, .gray)
    
    // MARK: - Setup Method
    init(_ type: CreateType) {
        super.init(frame: .zero)
        titleLabel.text = type.title
        descriptionLabel.text = type.description
        imageView.image = UIImage(named: type.image)
        
        switch type {
        case .tracking:
            dummyLabel.isHidden = true
        case .auto:
            dummyLabel.isHidden = false
        }
    }
    
    override func setupUI() {
        [titleLabel, descriptionLabel, imageView, dummyLabel].forEach {
            addSubview($0)
        }
    }
    
    override func setupConstraints() {
        let margin: CGFloat = 16
        
        titleLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview().offset(margin)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(margin / 2)
            make.horizontalEdges.equalToSuperview().inset(margin)
        }
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(margin / 2)
            make.horizontalEdges.bottom.equalToSuperview().inset(margin)
            make.height.greaterThanOrEqualTo(1)
        }
        imageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        
        dummyLabel.snp.makeConstraints { make in
            make.center.equalTo(imageView)
        }
    }
    
    override func setupAttributes() {
        layer.cornerRadius = 8
        clipsToBounds = true
        descriptionLabel.numberOfLines = 0
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.backgroundColor = AppColor.lightGray.value
        dummyLabel.text = C.prepared
    }
    
}
