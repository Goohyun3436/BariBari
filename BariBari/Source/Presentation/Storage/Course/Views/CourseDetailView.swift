//
//  CourseDetailView.swift
//  BariBari
//
//  Created by Goo on 4/2/25.
//

import UIKit
import SnapKit

final class CourseDetailView: BaseView {
    
    //MARK: - UI Property
    let editButton = IconButton(icon: .edit, selectedIcon: .check)
    let deleteButton = IconButton(icon: .delete)
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let imageView = UIImageView()
    private let titleLabel = AppLabel(.largeTitle)
    private let infoWrap = UIStackView()
    private let dateView = IconNLabelView(.calendar)
    private let folderView = IconNLabelView(.folder)
    private let contentLabel = AppLabel(.text2)
    let mapThumbnailView = MapThumbnailView()
    
    //MARK: - Setup Method
    func setData(_ info: Course) {
        if let imageData = info.image, let image = UIImage(data: imageData) {
            imageView.image = image
            updateImageViewHeight(for: image)
        }
        titleLabel.text = info.title
        dateView.label.text = info.date
        folderView.label.text = info.folderTitle
        contentLabel.text = info.content
        contentLabel.setLineSpacing(4)
    }
    
    override func setupUI() {
        [dateView, folderView].forEach {
            infoWrap.addArrangedSubview($0)
        }
        
        [imageView, titleLabel, infoWrap, contentLabel, mapThumbnailView].forEach {
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
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(marginV)
            make.leading.equalToSuperview().offset(marginH)
            make.trailing.lessThanOrEqualToSuperview().offset(-marginH)
        }
        
        infoWrap.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(marginV / 2)
            make.leading.equalToSuperview().offset(marginH)
            make.trailing.lessThanOrEqualToSuperview().offset(-marginH)
        }
        infoWrap.axis = .horizontal
        infoWrap.spacing = marginH
        infoWrap.alignment = .leading
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(infoWrap.snp.bottom).offset(marginV)
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
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = AppColor.lightGray.value
        titleLabel.numberOfLines = 0
        contentLabel.numberOfLines = 0
    }
    
    private func updateImageViewHeight(for image: UIImage) {
        let ratio = image.size.height / image.size.width
        
        imageView.snp.makeConstraints { make in
            make.height.equalTo(imageView.snp.width).multipliedBy(ratio)
        }
    }
    
}
