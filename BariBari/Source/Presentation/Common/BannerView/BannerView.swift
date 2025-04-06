//
//  BannerView.swift
//  BariBari
//
//  Created by Goo on 4/7/25.
//

import UIKit
import SnapKit

final class BannerView: BaseView {
    
    //MARK: - UI Property
    private let imageView = UIImageView()
    private let titleLabel = AppLabel(.title1, .white)
    private let locationView = IconNLabelView(.pin, .lightGray)
    private let gradientLayer = CAGradientLayer()
    
    //MARK: - Setup Method
    func setData(
        image: Data?,
        title: String,
        subText: String
    ) {
        if let image { imageView.image = UIImage(data: image) }
        titleLabel.text = title
        locationView.label.text = subText
    }
    
    override func setupUI() {
        [
            imageView,
            titleLabel,
            locationView
        ].forEach {
            addSubview($0)
        }
        
        layer.insertSublayer(gradientLayer, above: imageView.layer)
    }
    
    override func setupConstraints() {
        let padding: CGFloat = 16
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(padding)
            make.bottom.equalTo(locationView.snp.top).offset(-padding / 2)
        }
        
        locationView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(padding)
            make.trailing.lessThanOrEqualToSuperview().offset(-padding)
            make.bottom.equalTo(imageView.snp.bottom).offset(-padding)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    
    override func setupAttributes() {
        clipsToBounds = true
        layer.cornerRadius = 8
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = AppColor.lightGray.value
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.black.withAlphaComponent(0.7).cgColor
        ]
        gradientLayer.locations = [0.4, 1.0]
    }
}
