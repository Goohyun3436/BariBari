//
//  IconBasicTableViewCell.swift
//  BariBari
//
//  Created by Goo on 4/21/25.
//

import UIKit
import SnapKit

final class IconBasicTableViewCell: BaseTableViewCell {
    
    //MARK: - UI Property
    private let iconView = UIImageView()
    private let textWrap = UIStackView()
    private let titleLabel = AppLabel(.text1)
    private let subLabel = AppLabel(.subText2, .darkGray)
    
    //MARK: - Property
    static let id = "IconBasicTableViewCell"
    
    //MARK: - Override Method
    override func prepareForReuse() {
        iconView.image = nil
    }
    
    //MARK: - Setup Method
    func setData(icon: AppIcon, title: String, subText: String) {
        iconView.image = UIImage(systemName: icon.value)
        titleLabel.text = title
        subLabel.text = subText
    }
    
    override func setupUI() {
        [titleLabel, subLabel].forEach {
            textWrap.addArrangedSubview($0)
        }
        
        [iconView, textWrap].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func setupConstraints() {
        let iconSize: CGFloat = 30
        let textMargin: CGFloat = 8
        
        iconView.snp.makeConstraints { make in
            make.verticalEdges.leading.equalToSuperview().inset(16)
            make.size.equalTo(iconSize)
        }
        
        textWrap.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(16)
            make.leading.equalTo(iconView.snp.trailing)
        }
        textWrap.axis = .vertical
        textWrap.alignment = .leading
        textWrap.spacing = textMargin
    }
    
}
