//
//  BaseCollectionViewCell.swift
//  ios-movie-pedia
//
//  Created by Goo on 3/29/25.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
    
    var isEditing: Bool = false {
        didSet {
            isEditing ? startJiggling() : stopJiggling()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
        setupAttributes()
    }
    
    func setupUI() {}
    
    func setupConstraints() {}
    
    func setupAttributes() {}
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
