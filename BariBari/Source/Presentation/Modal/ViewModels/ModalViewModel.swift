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
        let cancelButtonColor: Observable<AppColor>
        let submitButtonColor: Observable<AppColor>
        let cancelButtonIsHidden: Observable<Bool>
    }
    
    //MARK: - Private
    private struct Private {
        let info: ModalInfo
        let cancelColor: AppColor
        let submitColor: AppColor
        let cancelHandler: (() -> Void)?
        let submitHandler: (() -> Void)?
        let disposeBag = DisposeBag()
    }
    
    //MARK: - Property
    private let priv: Private
    
    //MARK: - Initializer Method
    init(info: ModalInfo) {
        let destructive = [C.quitTitle, C.deleteTitle, C.resetTitle]
        
        let cancelColor = destructive.contains(info.cancelButtonTitle)
        ? AppColor.red
        : AppColor.black
        
        let submitColor = destructive.contains(info.submitButtonTitle)
        ? AppColor.red
        : AppColor.black
        
        priv = Private(
            info: info,
            cancelColor: cancelColor,
            submitColor: submitColor,
            cancelHandler: info.cancelHandler,
            submitHandler: info.submitHandler
        )
    }
    
    //MARK: - Transform
    func transform(input: Input) -> Output {
        let title = Observable<String>.just(priv.info.title)
        let message = Observable<String>.just(priv.info.message)
        let cancelButtonTitle = Observable<String>.just(priv.info.cancelButtonTitle)
        let submitButtonTitle = Observable<String>.just(priv.info.submitButtonTitle)
        let cancelButtonColor = Observable<AppColor>.just(priv.cancelColor)
        let submitButtonColor = Observable<AppColor>.just(priv.submitColor)
        let cancelButtonIsHidden = Observable<Bool>.just(priv.info.cancelHandler == nil)
        
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
            cancelButtonColor: cancelButtonColor,
            submitButtonColor: submitButtonColor,
            cancelButtonIsHidden: cancelButtonIsHidden
        )
    }
    
}
