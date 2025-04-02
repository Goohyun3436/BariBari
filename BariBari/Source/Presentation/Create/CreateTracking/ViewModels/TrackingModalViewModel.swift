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
        let presentVC: PublishRelay<BaseViewController>
        let dismissVC: PublishRelay<Void>
        let rootTBC: PublishRelay<Void>
    }
    
    //MARK: - Private
    private struct Private {
        let stopHandler: (() -> Void)?
        let disposeBag = DisposeBag()
    }
    
    //MARK: - Property
    private let priv: Private
    
    init(stopHandler: (() -> Void)?) {
        priv = Private(stopHandler: stopHandler)
    }
    
    //MARK: - Transform
    func transform(input: Input) -> Output {
        let presentVC = PublishRelay<BaseViewController>()
        let dismissVC = PublishRelay<Void>()
        let rootTBC = PublishRelay<Void>()
        
        input.stopTap
            .map { [weak self] in
                let vc = ModalViewController(
                    viewModel: ModalViewModel(
                        info: ModalInfo(
                            title: "경고",
                            message: "코스 추적을 종료하고 저장하시겠습니까?",
                            cancelHandler: {
                                dismissVC.accept(())
                            },
                            submitHandler: {
                                self?.priv.stopHandler?()
                                dismissVC.accept(())
                            }
                        )
                    )
                )
                vc.modalPresentationStyle = .overFullScreen
                vc.modalTransitionStyle = .crossDissolve
                return vc
            }
            .bind(to: presentVC)
            .disposed(by: priv.disposeBag)
        
        return Output(
            presentVC: presentVC,
            dismissVC: dismissVC,
            rootTBC: rootTBC
        )
    }
    
}
