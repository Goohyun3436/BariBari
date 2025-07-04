//
//  HomeDetailView.swift
//  BariBari
//
//  Created by Goo on 4/2/25.
//

import UIKit
import Kingfisher
import SnapKit

final class HomeDetailView: BaseView {
    
    //MARK: - UI Property
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let imageView = UIImageView()
    private let titleLabel = AppLabel(.largeTitle)
    private let contentLabel = AppLabel(.text2)
    let mapThumbnailView = MapThumbnailView()
    
    //MARK: - Setup Method
    func setData(_ info: Course) {
        if let imageUrl = info.imageUrl, let url = URL(string: imageUrl) {
            imageView.kf.setImage(with: url)
        }
        titleLabel.text = info.title
        contentLabel.text = info.content
        contentLabel.setLineSpacing(4)
        mapThumbnailView.setData(info.address, info.pins)
    }
    
    override func setupUI() {
        [imageView, titleLabel, contentLabel, mapThumbnailView].forEach {
            contentView.addSubview($0)
        }
        
        scrollView.addSubview(contentView)
        addSubview(scrollView)
    }
    
    override func setupConstraints() {
        let marginV: CGFloat = 24
        let marginH: CGFloat = 16
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.verticalEdges.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.lessThanOrEqualTo(200)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(marginV)
            make.leading.equalToSuperview().offset(marginH)
            make.trailing.lessThanOrEqualToSuperview().offset(-marginH)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(marginV)
            make.leading.equalToSuperview().offset(marginH)
            make.trailing.lessThanOrEqualToSuperview().offset(-marginH)
            make.bottom.lessThanOrEqualToSuperview().offset(-marginV)
        }
        
        mapThumbnailView.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(marginV * 2)
            make.horizontalEdges.equalToSuperview().inset(marginH)
            make.bottom.equalToSuperview().offset(-marginV)
        }
    }
    
    override func setupAttributes() {
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = AppColor.lightGray.value
        titleLabel.numberOfLines = 0
        contentLabel.numberOfLines = 0
    }
    
}
