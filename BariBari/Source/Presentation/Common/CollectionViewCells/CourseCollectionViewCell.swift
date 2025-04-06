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
    
    //MARK: - Setup Method
    func setData(
        image: Data?,
        title: String,
        subText: String
    ) {
        bannerView.setData(
            image: image,
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
