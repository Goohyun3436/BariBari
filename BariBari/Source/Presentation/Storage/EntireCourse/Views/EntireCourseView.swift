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
    let deleteButton = IconButton(icon: .delete, selectedIcon: .check)
    
    lazy var collectionView = GridCollectionView(
        itemsInRow: itemsInRow,
        itemH: itemH
    )
    let noneContentView = NoneContentView(.courseFolder)
    
    //MARK: - Property
    private let itemsInRow: CGFloat = 3
    private lazy var itemW: CGFloat = UIScreen.main.bounds.width / itemsInRow
    private lazy var itemH: CGFloat = itemW + 34
    
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
