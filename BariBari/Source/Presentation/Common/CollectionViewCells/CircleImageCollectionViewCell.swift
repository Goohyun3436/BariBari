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
    private let locationView = IconNLabelView(.pin)
    
    // MARK: - Property
    static let id = "CircleImageCollectionViewCell"
    private let imageInset: CGFloat = 8
    
    var isEditing: Bool = false {
        didSet {
            isEditing ? startJiggling() : stopJiggling()
        }
    }
    
    // MARK: - Override Method
    override func prepareForReuse() {
        imageView.image = nil
    }
    
    override func draw(_ rect: CGRect) {
        imageView.layer.cornerRadius = rect.size.width / 2 - imageInset
    }
    
    // MARK: - Setup Method
    func setData(image: Data?, title: String, subText: String) {
        if let image { imageView.image = UIImage(data: image) }
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
            make.top.equalToSuperview().offset(margin)
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
            make.bottom.lessThanOrEqualToSuperview().offset(-margin)
        }
    }
    
    override func setupAttributes() {
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = AppColor.lightGray.value
        titleLabel.textAlignment = .center
    }
    
    private func startJiggling() {
        let animation = CAKeyframeAnimation(keyPath: "transform.rotation")
        animation.values = [-0.05, 0.05, -0.05]
        animation.keyTimes = [0, 0.5, 1]
        animation.duration = 0.4
        animation.repeatCount = Float.infinity
        animation.isRemovedOnCompletion = false
        layer.add(animation, forKey: "jiggle")
    }
    
    private func stopJiggling() {
        layer.removeAnimation(forKey: "jiggle")
    }
    
}
