//
//  VerticalCollectionView.swift
//  BariBari
//
//  Created by Goo on 4/5/25.
//

import UIKit

final class VerticalCollectionView: UICollectionView {
    
    init(itemH: CGFloat? = nil) {
        super.init(frame: .zero, collectionViewLayout: {
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(100.0)
            )
            
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: itemH == nil ? .estimated(100.0) : .absolute(itemH!)
            )
            
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                subitems: [item]
            )
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(
                top: 8,
                leading: 16,
                bottom: 8,
                trailing: 16
            )
            let layout = UICollectionViewCompositionalLayout(section: section)
            return layout
        }())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
