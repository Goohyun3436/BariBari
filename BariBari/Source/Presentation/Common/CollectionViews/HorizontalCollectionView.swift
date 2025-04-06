//
//  HorizontalCollectionView.swift
//  BariBari
//
//  Created by Goo on 4/7/25.
//

import UIKit

final class HorizontalCollectionView: UICollectionView {
    
    init(itemW: CGFloat) {
        super.init(frame: .zero, collectionViewLayout: {
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .estimated(1),
                heightDimension: .fractionalHeight(1.0)
            )
            
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .absolute(itemW),
                heightDimension: .fractionalHeight(1.0)
            )
            
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(
                top: 8,
                leading: 8,
                bottom: 8,
                trailing: 8
            )
            
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                subitems: [item]
            )
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            section.contentInsets = NSDirectionalEdgeInsets(
                top: 0,
                leading: 8,
                bottom: 0,
                trailing: 8
            )
            let layout = UICollectionViewCompositionalLayout(section: section)
            return layout
        }())
        
        showsVerticalScrollIndicator = false
        isScrollEnabled = true
        alwaysBounceVertical = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
