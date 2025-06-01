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
        let quitTap: ControlEvent<Void>
        let itemTap: ControlEvent<ItemModel>
    }
    
    //MARK: - Output
    struct Output {
        let navigationTitle: Observable<String>
        let sections: Observable<[SectionModel]>
        let openURL: PublishRelay<URL>
        let dismissVC: PublishRelay<Void>
    }
    
    //MARK: - Private
    private struct Private {
        let disposeBag = DisposeBag()
    }
    
    //MARK: - Property
    private let priv = Private()
    
    //MARK: - Transform
    func transform(input: Input) -> Output {
        let navigationTitle = Observable<String>.just(C.aboutTitle)
        let sections = Observable<[SectionModel]>.just([
            AboutSection.version.value,
            AboutSection.link.value,
            AboutSection.creditThanks.value
        ])
        let openURL = PublishRelay<URL>()
        let dismissVC = PublishRelay<Void>()
        
        let itemTap = input.itemTap.share(replay: 1)
        
        input.quitTap
            .bind(to: dismissVC)
            .disposed(by: priv.disposeBag)
        
        itemTap
            .compactMap { $0.url }
            .bind(to: openURL)
            .disposed(by: priv.disposeBag)
        
        itemTap
            .map { $0.title }
            .bind(with: self) { owner, title in
                FirebaseAnalyticsManager.shared.logEventInScreen(
                    action: .about,
                    screen: .about,
                    additionalParams: ["item": title]
                )
            }
            .disposed(by: priv.disposeBag)
        
        return Output(
            navigationTitle: navigationTitle,
            sections: sections,
            openURL: openURL,
            dismissVC: dismissVC
        )
    }
    
}
