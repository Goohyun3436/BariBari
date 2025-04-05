//
//  CircleImageCollectionViewCell.swift
//  BariBari
//
//  Created by Goo on 4/5/25.
//

import UIKit
import SnapKit
import Kingfisher

final class CircleImageCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - UI Property
    private let imageView = UIImageView()
    private let titleLabel = AppLabel(.text1)
    private let subWrap = UIStackView()
    private let iconView = UIImageView()
    private let subTextLabel = AppLabel(.text3, .darkGray)
    
    // MARK: - Property
    static let id = "CircleImageCollectionViewCell"
    private let imageInset: CGFloat = 8
    
    // MARK: - Override Method
    override func draw(_ rect: CGRect) {
        imageView.layer.cornerRadius = rect.size.width / 2 - imageInset
    }
    
    // MARK: - Setup Method
    func setData(image: String?, title: String, subText: String) {
        if let image, let url = URL(string: image) {
            imageView.kf.setImage(with: url)
        }
        titleLabel.text = title
        subTextLabel.text = subText
    }
    
    override func setupUI() {
        [iconView, subTextLabel].forEach {
            subWrap.addArrangedSubview($0)
        }
        
        [imageView, titleLabel, subWrap].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func setupConstraints() {
        let margin: CGFloat = 8
        let iconSize: CGFloat = 12
        
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(imageInset)
            make.height.equalTo(imageView.snp.width)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(margin)
            make.horizontalEdges.equalToSuperview()
        }
        
        subWrap.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(margin)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(margin)
        }
        subWrap.axis = .horizontal
        subWrap.spacing = margin / 2
        
        iconView.snp.makeConstraints { make in
            make.size.equalTo(iconSize)
        }
    }
    
    override func setupAttributes() {
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = AppColor.lightGray.value
        titleLabel.textAlignment = .center
        iconView.image = UIImage(systemName: AppIcon.pin.value)
        iconView.tintColor = AppColor.gray.value
    }
}
