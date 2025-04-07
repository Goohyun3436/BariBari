//
//  CourseCollectionViewCell.swift
//  BariBari
//
//  Created by Goo on 4/7/25.
//

import UIKit
import SnapKit

final class CourseCollectionViewCell: BaseCollectionViewCell {
    
    //MARK: - UI Property
    private let bannerView = BannerView()
    
    //MARK: - Property
    static let id = "CourseCollectionViewCell"
    
    //MARK: - Override Method
    override func prepareForReuse() {
        bannerView.imageView.image = nil
    }
    
    //MARK: - Setup Method
    func setData(
        image: Data?,
        imageUrl: String?,
        title: String,
        subText: String
    ) {
        bannerView.setData(
            image: image,
            imageUrl: imageUrl,
            title: title,
            subText: subText
        )
    }
    
    override func setupUI() {
        contentView.addSubview(bannerView)
    }
    
    override func setupConstraints() {
        bannerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
