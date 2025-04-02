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
        let trackingStatus: BehaviorRelay<CreateTrackingStatus>
        let presentVC: PublishRelay<(vc: BaseViewController, detents: CGFloat)>
        let presentFormVC: PublishRelay<BaseViewController>
        let dismissVC: PublishRelay<Void>
        let rootTBC: PublishRelay<Void>
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
        let trackingStatus = BehaviorRelay<CreateTrackingStatus>(value: .ready)
        let presentVC = PublishRelay<(vc: BaseViewController, detents: CGFloat)>()
        let presentFormVC = PublishRelay<BaseViewController>()
        let dismissVC = PublishRelay<Void>()
        let rootTBC = PublishRelay<Void>()
        
        input.startTap
            .map { CreateTrackingStatus.tracking }
            .bind(to: trackingStatus)
            .disposed(by: priv.disposeBag)
        
        input.menuTap
            .map {
                let vc = TrackingModalViewController(
                    viewModel: TrackingModalViewModel(
                        cancelHandler: {
                            dismissVC.accept(())
                        },
                        completeHandler: {
                            dismissVC.accept(())
                            trackingStatus.accept(.complete)
                        }
                    )
                )
                return (vc: vc, detents: 0.15)
            }
            .bind(to: presentVC)
            .disposed(by: priv.disposeBag)
        
        trackingStatus
            .filter { $0 == .complete }
            .map { _ in
                CreateFormViewController(
                    viewModel: CreateFormViewModel(coords: [])
                )
            }
            .bind(to: presentFormVC)
            .disposed(by: priv.disposeBag)
        
        return Output(
            titleText: titleText,
            trackingStatus: trackingStatus,
            presentVC: presentVC,
            presentFormVC: presentFormVC,
            dismissVC: dismissVC,
            rootTBC: rootTBC
        )
    }
    
}
