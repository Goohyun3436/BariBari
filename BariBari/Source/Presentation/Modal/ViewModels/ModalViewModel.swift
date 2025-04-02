//
//  ModalViewModel.swift
//  BariBari
//
//  Created by Goo on 4/2/25.
//

import Foundation
import RxSwift
import RxCocoa

final class ModalViewModel: BaseViewModel {
    
    //MARK: - Input
    struct Input {
        let cancelTap: ControlEvent<Void>
        let submitTap: ControlEvent<Void>
    }
    
    //MARK: - Output
    struct Output {
        let title: Observable<String>
        let message: Observable<String>
        let cancelButtonTitle: Observable<String>
        let submitButtonTitle: Observable<String>
        let cancelButtonIsHidden: Observable<Bool>
    }
    
    //MARK: - Private
    private struct Private {
        let info: ModalInfo
        let cancelHandler: (() -> Void)?
        let submitHandler: (() -> Void)?
        let disposeBag = DisposeBag()
    }
    
    //MARK: - Property
    private let priv: Private
    
    //MARK: - Initializer Method
    init(info: ModalInfo) {
        priv = Private(
            info: info,
            cancelHandler: info.cancelHandler,
            submitHandler: info.submitHandler
        )
    }
    
    //MARK: - Transform
    func transform(input: Input) -> Output {
        let title = Observable.just(priv.info.title)
        let message = Observable.just(priv.info.message)
        let cancelButtonTitle = Observable.just(priv.info.cancelButtonTitle)
        let submitButtonTitle = Observable.just(priv.info.submitButtonTitle)
        let cancelButtonIsHidden = Observable.just(priv.info.cancelHandler == nil)
        
        input.cancelTap
            .bind(with: self, onNext: { owner, _ in
                owner.priv.cancelHandler?()
            })
            .disposed(by: priv.disposeBag)
        
        input.submitTap
            .bind(with: self, onNext: { owner, _ in
                owner.priv.submitHandler?()
            })
            .disposed(by: priv.disposeBag)
        
        return Output(
            title: title,
            message: message,
            cancelButtonTitle: cancelButtonTitle,
            submitButtonTitle: submitButtonTitle,
            cancelButtonIsHidden: cancelButtonIsHidden
        )
    }
    
}
