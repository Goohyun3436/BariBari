//
//  CreateTrackingViewModel.swift
//  BariBari
//
//  Created by Goo on 4/2/25.
//

import Foundation
import RxSwift
import RxCocoa

final class CreateTrackingViewModel: BaseViewModel {
    
    //MARK: - Input
    struct Input {
        let startTap: ControlEvent<Void>
        let menuTap: ControlEvent<Void>
    }
    
    //MARK: - Output
    struct Output {
        let titleText: Observable<String>
        let isTracking: BehaviorRelay<Bool>
        let presentVC: PublishRelay<(vc: BaseViewController, detents: CGFloat)>
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
        let titleText = Observable.just(C.createTrackingTitle)
        let isTracking = BehaviorRelay(value: false)
        let presentVC = PublishRelay<(vc: BaseViewController, detents: CGFloat)>()
        let dismissVC = PublishRelay<Void>()
        
        input.startTap
            .map { true }
            .bind(to: isTracking)
            .disposed(by: priv.disposeBag)
        
        input.menuTap
            .map {
                let vc = TrackingModalViewController(
                    viewModel: TrackingModalViewModel(
                        stopHandler: {
                            isTracking.accept(false)
                            dismissVC.accept(())
                        }
                    )
                )
                return (vc: vc, detents: 0.2)
            }
            .bind(to: presentVC)
            .disposed(by: priv.disposeBag)
        
        return Output(
            titleText: titleText,
            isTracking: isTracking,
            presentVC: presentVC,
            dismissVC: dismissVC
        )
    }
    
}
