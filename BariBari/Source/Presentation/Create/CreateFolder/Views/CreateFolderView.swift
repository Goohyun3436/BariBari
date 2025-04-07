//
//  CreateFolderView.swift
//  BariBari
//
//  Created by Goo on 4/4/25.
//

import UIKit
import SnapKit

final class CreateFolderView: BaseView {
    
    //MARK: - UI Property
    private let wrap = UIView()
    let titleLabel = AppLabel(.title2)
    let imageField = CreateImageField()
    let titleField = CreateField(.textField, title: C.courseTitle)
    private let buttonWrap = UIStackView()
    let cancelButton = UIButton()
    let submitButton = UIButton()
    
    //MARK: - Setup Method
    override func setupUI() {
        [cancelButton, submitButton].forEach {
            buttonWrap.addArrangedSubview($0)
        }
        
        [titleLabel, imageField, titleField, buttonWrap].forEach {
            wrap.addSubview($0)
        }
        
        addSubview(wrap)
    }
    
    override func setupConstraints() {
        let modalHMargin: CGFloat = 50
        let paddingV: CGFloat = 20
        let paddingH: CGFloat = 16
        let imageH: CGFloat = 80
        let buttonH: CGFloat = 44
        
        wrap.snp.makeConstraints { make in
            make.centerY.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(modalHMargin)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(paddingV)
            make.centerX.equalToSuperview()
        }
        
        imageField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(paddingV)
            make.centerX.equalToSuperview().inset(paddingH)
            make.size.equalTo(imageH)
        }
        
        titleField.snp.makeConstraints { make in
            make.top.equalTo(imageField.snp.bottom).offset(paddingV)
            make.horizontalEdges.equalToSuperview().inset(paddingH)
        }
        
        buttonWrap.snp.makeConstraints { make in
            make.top.equalTo(titleField.snp.bottom).offset(paddingV)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(buttonH)
            make.bottom.equalToSuperview()
        }
        buttonWrap.axis = .horizontal
        buttonWrap.spacing = 0
        buttonWrap.distribution = .fillEqually
    }
    
    override func setupAttributes() {
        backgroundColor = AppColor.overlay.value
        wrap.layer.cornerRadius = 8
        wrap.clipsToBounds = true
        wrap.backgroundColor = AppColor.white.value
        cancelButton.setTitle(C.cancelTitle, for: .normal)
        [cancelButton, submitButton].forEach {
            $0.setTitleColor(AppColor.black.value, for: .normal)
            $0.titleLabel?.font = AppFont.title2.value
        }
    }
    
    
}
