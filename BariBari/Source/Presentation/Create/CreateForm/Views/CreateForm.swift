//
//  CreateForm.swift
//  BariBari
//
//  Created by Goo on 4/3/25.
//

import UIKit
import SnapKit

enum FieldType {
    case textField
    case textView
}

final class CreateField: BaseView {
    
    //MARK: - UI Property
    private let titleLabel = AppLabel(.title3)
    let textField = UITextField()
    let textView = UITextView()
    
    init(_ type: FieldType, title: String) {
        super.init(frame: .zero)
        setupUI(for: type)
        setupConstraints(for: type)
        titleLabel.text = title
    }
    
    //MARK: - Setup Method
    private func setupUI(for type: FieldType) {
        addSubview(titleLabel)
        switch type {
        case .textField:
            addSubview(textField)
        case .textView:
            addSubview(textView)
        }
    }
    
    private func setupConstraints(for type: FieldType) {
        let margin: CGFloat = 8
        let textFieldH: CGFloat = 34
        
        titleLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
        }
        
        switch type {
        case .textField:
            textField.snp.makeConstraints { make in
                make.top.equalTo(titleLabel.snp.bottom).offset(margin)
                make.height.equalTo(textFieldH)
                make.horizontalEdges.bottom.equalToSuperview()
            }
        case .textView:
            textView.snp.makeConstraints { make in
                make.top.equalTo(titleLabel.snp.bottom).offset(margin)
                make.horizontalEdges.bottom.equalToSuperview()
            }
        }
    }
    
    override func setupAttributes() {
        let padding: CGFloat = 12
        
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        textField.borderStyle = .none
        textField.clipsToBounds = true
        textField.layer.cornerRadius = 4
        textField.leftView = UIView(frame: CGRect(
            x: 0, y: 0, width: padding, height: textField.frame.height
        ))
        textField.leftViewMode = .always
        textField.attributedPlaceholder = NSAttributedString(
            string: C.textFiledPlaceholder,
            attributes: [.foregroundColor: AppColor.black.value]
        )
        textView.layer.cornerRadius = 5
        textView.textContainerInset = UIEdgeInsets(
            top: padding, left: padding, bottom: padding, right: padding
        )
        textView.text = C.textFiledPlaceholder //refactor 초기에 값 없을때만
    }
    
}
