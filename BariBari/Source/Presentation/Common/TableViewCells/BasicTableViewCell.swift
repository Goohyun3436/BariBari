//
//  BasicTableViewCell.swift
//  BariBari
//
//  Created by Goo on 4/21/25.
//

import UIKit
import SnapKit

final class BasicTableViewCell: BaseTableViewCell {
    
    //MARK: - UI Property
    private let iconWrap = UIView()
    private let iconView = IconView(color: .darkGray)
    private let textWrap = UIStackView()
    private let titleLabel = AppLabel(.text2)
    private let subLabel = AppLabel(.subText2, .darkGray)
    private let moreIcon = IconView(color: .gray)
    
    //MARK: - Property
    static let id = "BasicTableViewCell"
    
    //MARK: - Override Method
    override func prepareForReuse() {
        iconView.image = nil
        moreIcon.image = nil
    }
    
    //MARK: - Setup Method
    func setData(_ info: ItemModel) {
        iconView.image = UIImage(
            systemName: info.icon.value,
            withConfiguration: UIImage.SymbolConfiguration(
                font: AppFont.title4.value
            )
        )
        titleLabel.text = info.title
        subLabel.text = info.subText
        subLabel.isHidden = info.subText == nil
        moreIcon.isHidden = !info.isMoreIcon
    }
    
    override func setupUI() {
        iconWrap.addSubview(iconView)
        
        [titleLabel, subLabel].forEach {
            textWrap.addArrangedSubview($0)
        }
        
        [iconWrap, textWrap, moreIcon].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func setupConstraints() {
        let margin: CGFloat = 16
        let leftIconW: CGFloat = 24
        
        iconWrap.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(margin)
            make.width.equalTo(leftIconW)
        }
        
        iconView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        textWrap.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(margin)
            make.leading.equalTo(iconWrap.snp.trailing).offset(margin / 2)
            make.trailing.lessThanOrEqualTo(moreIcon.snp.leading).offset(-margin / 2)
        }
        textWrap.axis = .vertical
        textWrap.alignment = .leading
        textWrap.spacing = margin / 8
        
        moreIcon.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(margin)
        }
    }
    
    override func setupAttributes() {
        selectionStyle = .none
        moreIcon.image = UIImage(
            systemName: AppIcon.arrowRight.value,
            withConfiguration: UIImage.SymbolConfiguration(
                font: AppFont.subText2.value
            )
        )
    }
    
}
