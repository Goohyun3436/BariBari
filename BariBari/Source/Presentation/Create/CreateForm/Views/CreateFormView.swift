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
    let quitButton = UIButton()
    let saveButton = UIButton()
    
    //MARK: - Setup Method
    override func setupUI() {
        [quitButton, saveButton].forEach {
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
        
        quitButton.snp.makeConstraints { make in
            make.height.equalTo(buttonH)
        }
        
        saveButton.snp.makeConstraints { make in
            make.height.equalTo(buttonH)
        }
    }
    
    override func setupAttributes() {
        buttonWrap.backgroundColor = AppColor.white.value
        quitButton.clipsToBounds = true
        quitButton.layer.cornerRadius = 8
        quitButton.layer.borderColor = AppColor.lightGray.value.cgColor
        quitButton.layer.borderWidth = 1
        quitButton.setTitle(C.cancelTitle, for: .normal)
        quitButton.backgroundColor = AppColor.white.value
        quitButton.setTitleColor(AppColor.black.value, for: .normal)
        quitButton.titleLabel?.font = AppFont.title2.value
        saveButton.clipsToBounds = true
        saveButton.layer.cornerRadius = 8
        saveButton.setTitle(C.saveTitle, for: .normal)
        saveButton.backgroundColor = AppColor.black.value
        saveButton.setTitleColor(AppColor.white.value, for: .normal)
        saveButton.titleLabel?.font = AppFont.title2.value
    }
    
    
}
