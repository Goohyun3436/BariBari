//
//  CircleImageCollectionViewCell.swift
//  BariBari
//
//  Created by Goo on 4/5/25.
//

import UIKit
import SnapKit

final class CircleImageCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - UI Property
    private let imageView = UIImageView()
    private let titleLabel = AppLabel(.text1)
    private let locationView = IconNLabelView(icon: .pin)
    
    // MARK: - Property
    static let id = "CircleImageCollectionViewCell"
    private let imageInset: CGFloat = 8
    
    // MARK: - Override Method
    override func draw(_ rect: CGRect) {
        imageView.layer.cornerRadius = rect.size.width / 2 - imageInset
    }
    
    // MARK: - Setup Method
    func setData(image: String?, title: String, subText: String) {
        imageView.image = UIImage(systemName: "")  //refactor base64
        titleLabel.text = title
        locationView.label.text = subText
    }
    
    override func setupUI() {
        [imageView, titleLabel, locationView].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func setupConstraints() {
        let margin: CGFloat = 8
        
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(imageInset)
            make.height.equalTo(imageView.snp.width)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(margin)
            make.horizontalEdges.equalToSuperview()
        }
        
        locationView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(margin)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(margin)
        }
    }
    
    override func setupAttributes() {
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = AppColor.lightGray.value
        titleLabel.textAlignment = .center
    }
}
