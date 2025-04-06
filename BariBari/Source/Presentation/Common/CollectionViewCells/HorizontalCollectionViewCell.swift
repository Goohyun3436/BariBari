//
//  HorizontalCollectionViewCell.swift
//  BariBari
//
//  Created by Goo on 4/5/25.
//

import UIKit
import SnapKit

final class HorizontalCollectionViewCell: BaseCollectionViewCell {
    
    //MARK: - UI Property
    private let imageView = UIImageView()
    private let titleLabel = AppLabel(.text1)
    private let locationView = IconNLabelView(icon: .pin)
    private let contentLabel = AppLabel(.subText2, .darkGray)
    private let dateLabel = AppLabel(.subText3, .gray)
    
    //MARK: - Property
    static let id = "HorizontalCollectionViewCell"
    
    // MARK: - Override Method
    override func prepareForReuse() {
        imageView.image = nil
    }
    
    //MARK: - Setup Method
    func setData(
        image: Data?,
        title: String,
        subText: String,
        content: String?,
        date: String
    ) {
        if let image { imageView.image = UIImage(data: image) }
        titleLabel.text = title
        locationView.label.text = subText
        contentLabel.text = content
        dateLabel.text = date
        contentLabel.setLineSpacing(4)
    }
    
    override func setupUI() {
        [
            imageView,
            titleLabel,
            locationView,
            contentLabel,
            dateLabel
        ].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func setupConstraints() {
        let margin: CGFloat = 8
        
        imageView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(margin)
            make.leading.equalToSuperview()
            make.width.equalTo(imageView.snp.height)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.top).offset(margin)
            make.leading.equalTo(imageView.snp.trailing).offset(margin)
            make.trailing.lessThanOrEqualToSuperview().offset(-margin)
        }
        
        locationView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(margin)
            make.leading.equalTo(imageView.snp.trailing).offset(margin)
            make.trailing.lessThanOrEqualToSuperview().offset(-margin)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(locationView.snp.bottom).offset(margin)
            make.leading.equalTo(imageView.snp.trailing).offset(margin)
            make.trailing.lessThanOrEqualToSuperview().offset(-margin)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.leading.greaterThanOrEqualTo(imageView.snp.trailing).offset(margin)
            make.bottom.equalToSuperview().inset(margin)
        }
    }
    
    override func setupAttributes() {
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = AppColor.lightGray.value
        contentLabel.numberOfLines = 3
        contentLabel.lineBreakMode = .byTruncatingTail
    }
    
}
