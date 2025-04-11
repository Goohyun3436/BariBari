//
//  HomeView.swift
//  BariBari
//
//  Created by Goo on 4/2/25.
//

import UIKit
import SnapKit

final class HomeView: BaseView {
    
    //MARK: - UI Property
    private let titleLabel = AppLabel(.title1)
    let bannerView = BannerView()
    private let coursesHeaderView = SectionHeaderView()
    lazy var collectionView = HorizontalCollectionView(itemW: itemW)
    
    //MARK: - Property
    private let itemsInRow: CGFloat = 1.8
    private lazy var itemW: CGFloat = UIScreen.main.bounds.width / itemsInRow
    
    //MARK: - Setup Method
    override func setupUI() {
        collectionView.register(
            CourseCollectionViewCell.self,
            forCellWithReuseIdentifier: CourseCollectionViewCell.id
        )
        
        [titleLabel, bannerView, coursesHeaderView, collectionView].forEach {
            addSubview($0)
        }
    }
    
    override func setupConstraints() {
        let sectionMarginV: CGFloat = 50
        let marginV: CGFloat = 32
        let marginH: CGFloat = 16
        let bannerH: CGFloat = UIScreen.main.bounds.height * 0.24
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(marginV)
            make.horizontalEdges.equalToSuperview().inset(marginH)
        }
        
        bannerView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(marginV / 2)
            make.horizontalEdges.equalToSuperview().inset(marginH)
            make.height.equalTo(bannerH)
        }
        
        coursesHeaderView.snp.makeConstraints { make in
            make.top.equalTo(bannerView.snp.bottom).offset(sectionMarginV)
            make.horizontalEdges.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(coursesHeaderView.snp.bottom).offset(marginV / 2)
            make.horizontalEdges.equalToSuperview()
            make.height.greaterThanOrEqualTo(1)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(marginV / 2)
        }
        collectionView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
    }
    
    override func setupAttributes() {
        titleLabel.text = C.mainTitle
        coursesHeaderView.titleLabel.text = C.mainSubTitle
    }
    
}
