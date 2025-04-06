//
//  GridCollectionView.swift
//  BariBari
//
//  Created by Goo on 4/5/25.
//

import UIKit

final class GridCollectionView: UICollectionView {
    
    init(itemsInRow: CGFloat, itemH: CGFloat) {
        super.init(frame: .zero, collectionViewLayout: {
            let sectionInset: CGFloat = 16
            let itemInset: CGFloat = 4
            let insets = (itemsInRow - 1) * itemInset + sectionInset
            let itemW = (UIScreen.main.bounds.width - insets) / itemsInRow
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(itemH)
            )
            
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .absolute(itemW),
                heightDimension: .absolute(itemH)
            )
            
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(
                top: itemInset,
                leading: itemInset,
                bottom: itemInset,
                trailing: itemInset
            )
            
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                subitems: [item]
            )
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(
                top: sectionInset - itemInset,
                leading: sectionInset - itemInset,
                bottom: sectionInset - itemInset,
                trailing: sectionInset - itemInset
            )
            let layout = UICollectionViewCompositionalLayout(section: section)
            return layout
        }())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
