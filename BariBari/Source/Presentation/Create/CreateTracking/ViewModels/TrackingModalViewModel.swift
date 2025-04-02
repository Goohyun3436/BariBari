//
//  TrackingModalViewModel.swift
//  BariBari
//
//  Created by Goo on 4/2/25.
//

import Foundation
import RxSwift
import RxCocoa

final class TrackingModalViewModel: BaseViewModel {
    
    //MARK: - Input
    struct Input {
        let stopTap: ControlEvent<Void>
    }
    
    //MARK: - Output
    struct Output {
        let presentModalVC: PublishRelay<BaseViewController>
        let dismissVC: PublishRelay<Void>
    }
    
    //MARK: - Private
    private struct Private {
        let cancelHandler: (() -> Void)?
        let completeHandler: (() -> Void)?
        let disposeBag = DisposeBag()
    }
    
    //MARK: - Property
    private let priv: Private
    
    init(cancelHandler: (() -> Void)?, completeHandler: (() -> Void)?) {
        priv = Private(
            cancelHandler: cancelHandler,
            completeHandler: completeHandler
        )
    }
    
    //MARK: - Transform
    func transform(input: Input) -> Output {
        let presentModalVC = PublishRelay<BaseViewController>()
        let dismissVC = PublishRelay<Void>()
        
        input.stopTap
            .map { [weak self] in
                ModalViewController(
                    viewModel: ModalViewModel(
                        info: ModalInfo(
                            title: "경고",
                            message: "코스 추적을 종료하고 저장하시겠습니까?",
                            cancelHandler: {
                                dismissVC.accept(())
                                self?.priv.cancelHandler?()
                            },
                            submitHandler: {
                                self?.priv.completeHandler?() //refactor 호출 순서 디버깅
                                dismissVC.accept(())
                            }
                        )
                    )
                )
            }
            .bind(to: presentModalVC)
            .disposed(by: priv.disposeBag)
        
        return Output(
            presentModalVC: presentModalVC,
            dismissVC: dismissVC
        )
    }
    
}
