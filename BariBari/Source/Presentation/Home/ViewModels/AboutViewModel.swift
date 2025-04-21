//
//  AboutViewModel.swift
//  BariBari
//
//  Created by Goo on 4/21/25.
//

import Foundation
import RxSwift
import RxCocoa

final class AboutViewModel: BaseViewModel {
    
    //MARK: - Input
    struct Input {
    }
    
    //MARK: - Output
    struct Output {
        let sections: Observable<[SectionModel]>
    }
    
    //MARK: - Private
    private struct Private {
        let disposeBag = DisposeBag()
    }
    
    //MARK: - Property
    private let priv = Private()
    
    //MARK: - Transform
    func transform(input: Input) -> Output {
        let sections = Observable<[SectionModel]>.just([
            SectionModel(
                header: AppInfoVersionType.title,
                items: AppInfoVersionType.allCases.map {
                    ItemModel(icon: $0.icon, title: $0.title, subText: $0.subText)
                }
            ),
            SectionModel(
                header: AppInfoLinkType.title,
                items: AppInfoLinkType.allCases.map {
                    ItemModel(icon: $0.icon, title: $0.title, isMoreIcon: true)
                }
            ),
            SectionModel(
                header: AppCreditThanksType.title,
                items: AppCreditThanksType.allCases.map {
                    ItemModel(icon: $0.icon, title: $0.title, isMoreIcon: true)
                }
            )
        ])
        
        return Output(
            sections: sections
        )
    }
    
}
