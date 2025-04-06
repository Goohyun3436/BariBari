//
//  CourseView.swift
//  BariBari
//
//  Created by Goo on 4/2/25.
//

import UIKit
import SnapKit

final class CourseView: BaseView {
    
    //MARK: - UI Property
    let editButton = EditButton()
    let collectionView = VerticalCollectionView(itemH: 130)
    let noneContentView = NoneContentView(.course)
    
    //MARK: - Setup Method
    override func setupUI() {
        collectionView.register(
            HorizontalCollectionViewCell.self,
            forCellWithReuseIdentifier: HorizontalCollectionViewCell.id
        )
        
        [collectionView, noneContentView].forEach {
            addSubview($0)
        }
    }
    
    override func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
        
        noneContentView.snp.makeConstraints { make in
            make.center.equalTo(safeAreaLayoutGuide)
        }
    }
    
    override func setupAttributes() {
        collectionView.bounces = false
    }
    
}
