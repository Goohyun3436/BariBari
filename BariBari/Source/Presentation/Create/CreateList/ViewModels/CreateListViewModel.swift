//
//  CreateListViewModel.swift
//  BariBari
//
//  Created by Goo on 4/2/25.
//

import Foundation
import RxSwift
import RxCocoa
import RxGesture

final class CreateListViewModel: BaseViewModel {
    
    //MARK: - Input
    struct Input {
        let trackingCardTap: TapControlEvent
        let autoTap: TapControlEvent
    }
    
    //MARK: - Output
    struct Output {
        let rootVC: PublishRelay<BaseViewController>
    }
    
    //MARK: - Private
    private struct Private {
        let disposeBag = DisposeBag()
    }
    
    //MARK: - Property
    private let priv = Private()
    
    //MARK: - Transform
    func transform(input: Input) -> Output {
        let rootVC = PublishRelay<BaseViewController>()
        
        input.trackingCardTap
            .when(.recognized)
            .map { _ in
                CreateTrackingViewController()
            }
            .bind(to: rootVC)
            .disposed(by: priv.disposeBag)
        
        input.autoTap
            .when(.recognized)
            .map { _ in
                CreateAutoViewController()
            }
            .bind(to: rootVC)
            .disposed(by: priv.disposeBag)
        
        return Output(
            rootVC: rootVC
        )
    }
    
}
