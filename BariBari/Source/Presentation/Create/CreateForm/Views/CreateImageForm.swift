//
//  CreateImageForm.swift
//  BariBari
//
//  Created by Goo on 4/3/25.
//

import UIKit
import SnapKit

final class CreateImageField: BaseView {
    
    //MARK: - UI Property
    let imageView = UIImageView()
    private let imageIcon = UIImageView()
    
    //MARK: - Property
    private let iconSize: CGFloat = 30
    
    //MARK: - Setup Method
    override func setupUI() {
        [imageView, imageIcon].forEach {
            addSubview($0)
        }
    }
    
    override func setupConstraints() {
        let iconOffset: CGFloat = 4
        let iconSize: CGFloat = 16
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        imageIcon.snp.makeConstraints { make in
            make.trailing.bottom.equalTo(imageView).offset(iconOffset)
            make.size.equalTo(iconSize)
        }
    }
    
    override func setupAttributes() {
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = AppColor.lightGray.value
        
        imageIcon.contentMode = .scaleAspectFit
        imageIcon.image = UIImage(systemName: AppIcon.camera.value)
        imageIcon.tintColor = AppColor.black.value
    }
}
