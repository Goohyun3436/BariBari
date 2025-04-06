//
//  EntireCourseView.swift
//  BariBari
//
//  Created by Goo on 4/2/25.
//

import UIKit
import SnapKit

final class EntireCourseView: BaseView {
    
    //MARK: - UI Property
    let editButton = EditButton()
    let collectionView = GridCollectionView(
        itemsInRow: 3,
        itemH: 150
    )
    let noneContentView = NoneContentView(.courseFolder)
    
    //MARK: - Setup Method
    override func setupUI() {
        collectionView.register(
            CircleImageCollectionViewCell.self,
            forCellWithReuseIdentifier: CircleImageCollectionViewCell.id
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
