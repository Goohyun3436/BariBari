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
    let folderPicker = CourseFolderPickerButton()
    let imageField = CreateImageField()
    let titleField = CreateField(.textField, title: C.courseTitle)
    let contentField = CreateField(.textView, title: C.courseContent)
    private let buttonWrap = UIStackView()
    let quitButton = TitleButton(title: C.cancelTitle, borderColor: .border)
    let saveButton = TitleButton(title: C.saveTitle, color: .white, bgColor: .black)
    
    //MARK: - Setup Method
    override func setupUI() {
        [quitButton, saveButton].forEach {
            buttonWrap.addArrangedSubview($0)
        }
        
        [imageField, titleField, folderPicker, contentField, buttonWrap].forEach {
            addSubview($0)
        }
    }
    
    override func setupConstraints() {
        let marginTop: CGFloat = 50
        let marginV: CGFloat = 24
        let marginH: CGFloat = 16
        let imageH: CGFloat = 70
        let folderPickerMinW: CGFloat = 180
        let contentH: CGFloat = 200
        let buttonWrapH: CGFloat = 80
        let buttonH: CGFloat = 44
        
        folderPicker.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(marginTop + 4)
            make.trailing.equalToSuperview().inset(marginH)
            make.width.lessThanOrEqualTo(folderPickerMinW)
        }
        
        imageField.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(marginTop)
            make.leading.equalToSuperview().offset(marginH)
            make.size.equalTo(imageH)
        }
        
        titleField.snp.makeConstraints { make in
            make.bottom.equalTo(imageField.snp.bottom)
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
    }
    
}
