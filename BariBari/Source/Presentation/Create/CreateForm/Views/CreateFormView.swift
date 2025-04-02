//
//  CreateFormView.swift
//  BariBari
//
//  Created by Goo on 4/2/25.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class CreateFormView: BaseView {
    
    //MARK: - UI Property
    let imageField = CreateImageField()
    let titleField = CreateField(.textField, title: C.courseTitle)
    let contentField = CreateField(.textView, title: C.courseContent)
    private let buttonWrap = UIStackView()
    let cancelButton = UIButton()
    let submitButton = UIButton()
    
    //MARK: - Setup Method
    override func setupUI() {
        [cancelButton, submitButton].forEach {
            buttonWrap.addArrangedSubview($0)
        }
        
        [imageField, titleField, contentField, buttonWrap].forEach {
            addSubview($0)
        }
    }
    
    override func setupConstraints() {
        let marginTop: CGFloat = 50
        let marginV: CGFloat = 32
        let marginH: CGFloat = 16
        let imageH: CGFloat = 70
        let contentH: CGFloat = 200
        let buttonWrapH: CGFloat = 80
        let buttonH: CGFloat = 44
        
        imageField.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(marginTop)
            make.size.equalTo(imageH)
            make.leading.equalToSuperview().offset(marginH)
        }
        
        titleField.snp.makeConstraints { make in
            make.centerY.equalTo(imageField.snp.centerY)
            make.leading.equalTo(imageField.snp.trailing).offset(marginH)
            make.trailing.equalToSuperview().inset(marginH)
        }
        
        contentField.snp.makeConstraints { make in
            make.top.equalTo(titleField.snp.bottom).offset(marginV)
            make.horizontalEdges.equalToSuperview().inset(marginH)
            make.height.equalTo(contentH)
        }
        
        buttonWrap.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(marginH)
            make.height.equalTo(buttonWrapH)
            make.bottom.equalToSuperview()
        }
        buttonWrap.axis = .horizontal
        buttonWrap.spacing = marginH
        buttonWrap.distribution = .fillEqually
        buttonWrap.alignment = .top
        
        cancelButton.snp.makeConstraints { make in
            make.height.equalTo(buttonH)
        }
        
        submitButton.snp.makeConstraints { make in
            make.height.equalTo(buttonH)
        }
    }
    
    override func setupAttributes() {
        buttonWrap.backgroundColor = AppColor.white.value
        cancelButton.clipsToBounds = true
        cancelButton.layer.cornerRadius = 8
        cancelButton.layer.borderColor = AppColor.lightGray.value.cgColor
        cancelButton.layer.borderWidth = 1
        cancelButton.setTitle(C.cancelTitle, for: .normal)
        cancelButton.backgroundColor = AppColor.white.value
        cancelButton.setTitleColor(AppColor.black.value, for: .normal)
        cancelButton.titleLabel?.font = AppFont.title2.value
        submitButton.clipsToBounds = true
        submitButton.layer.cornerRadius = 8
        submitButton.setTitle(C.saveTitle, for: .normal)
        submitButton.backgroundColor = AppColor.black.value
        submitButton.setTitleColor(AppColor.white.value, for: .normal)
        submitButton.titleLabel?.font = AppFont.title2.value
    }
    
    
}
