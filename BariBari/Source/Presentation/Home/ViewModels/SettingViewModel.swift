//
//  SettingViewModel.swift
//  BariBari
//
//  Created by Goo on 4/22/25.
//

import Foundation
import RxSwift
import RxCocoa

final class SettingViewModel: BaseViewModel {
    
    //MARK: - Input
    struct Input {
        let quitTap: ControlEvent<Void>
        let itemTap: ControlEvent<IndexPath>
    }
    
    //MARK: - Output
    struct Output {
        let navigationTitle: Observable<String>
        let sections: Observable<[SectionModel]>
        let presentModalVC: PublishRelay<BaseViewController>
        let dismissVC: PublishRelay<Void>
    }
    
    //MARK: - Private
    private struct Private {
        let resetConfirm = PublishRelay<Void>()
        let resetTrigger = PublishRelay<Void>()
        let error = PublishRelay<AppError>()
        let disposeBag = DisposeBag()
    }
    
    //MARK: - Property
    private let priv = Private()
    
    //MARK: - Transform
    func transform(input: Input) -> Output {
        let navigationTitle = Observable<String>.just(C.settingTitle)
        let sections = Observable<[SectionModel]>.just([
            SettingSection.system.value
        ])
        let presentModalVC = PublishRelay<BaseViewController>()
        let dismissVC = PublishRelay<Void>()
        
        input.quitTap
            .bind(to: dismissVC)
            .disposed(by: priv.disposeBag)
        
        input.itemTap
            .bind(with: self) { owner, indexPath in
                let (section, row) = (indexPath[0], indexPath[1])
                switch SettingSection.allCases[section] {
                case .system:
                    switch SettingSystemType.allCases[row] {
                    case .reset:
                        owner.priv.resetConfirm.accept(())
                    }
                }
            }
            .disposed(by: priv.disposeBag)
        
        priv.resetConfirm
            .map { [weak self] _ in
                ModalViewController(
                    viewModel: ModalViewModel(
                        info: ModalInfo(
                            title: C.warning,
                            message: C.resetMessage,
                            submitButtonTitle: C.resetTitle,
                            cancelHandler: {
                                dismissVC.accept(())
                            },
                            submitHandler: {
                                self?.priv.resetTrigger.accept(())
                                dismissVC.accept(())
                            }
                        )
                    )
                )
            }
            .bind(to: presentModalVC)
            .disposed(by: priv.disposeBag)
        
        priv.resetTrigger
            .flatMap {
                RealmRepository.shared.reset()
            }
            .bind(with: self) { owner, result in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    switch result {
                    case .success():
                        presentModalVC.accept(ModalViewController(
                            viewModel: ModalViewModel(
                                info: ModalInfo(
                                    title: C.info,
                                    message: C.resetConfirmMessage,
                                    submitHandler: {
                                        dismissVC.accept(())
                                        dismissVC.accept(())
                                    }
                                )
                            )
                        ))
                    case .failure(let error):
                        owner.priv.error.accept(error)
                    }
                }
            }
            .disposed(by: priv.disposeBag)
        
        priv.error
            .map {
                ModalViewController(
                    viewModel: ModalViewModel(
                        info: ModalInfo(
                            title: $0.title,
                            message: $0.message,
                            submitHandler: { dismissVC.accept(()) }
                        )
                    )
                )
            }
            .bind(to: presentModalVC)
            .disposed(by: priv.disposeBag)
        
        return Output(
            navigationTitle: navigationTitle,
            sections: sections,
            presentModalVC: presentModalVC,
            dismissVC: dismissVC
        )
    }
    
}
