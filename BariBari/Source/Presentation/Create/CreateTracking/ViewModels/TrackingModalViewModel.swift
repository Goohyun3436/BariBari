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
        let quitTap: ControlEvent<Void>
        let saveTap: ControlEvent<Void>
    }
    
    //MARK: - Output
    struct Output {
        let presentModalVC: PublishRelay<BaseViewController>
        let dismissVC: PublishRelay<Void>
        let rootTBC: PublishRelay<Void>
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
        let rootTBC = PublishRelay<Void>()
        
        input.quitTap
            .map { [weak self] in
                ModalViewController(
                    viewModel: ModalViewModel(
                        info: ModalInfo(
                            title: C.warning,
                            message: C.createFormQuitMessage,
                            submitButtonTitle: C.quitTitle,
                            cancelHandler: {
                                dismissVC.accept(())
                                self?.priv.cancelHandler?()
                            },
                            submitHandler: {
                                LocationManager.shared.stopTracking()
                                FirebaseAnalyticsManager.shared.logEventInScreen(
                                    action: .createTrackingStop,
                                    screen: .createTracking
                                )
                                rootTBC.accept(())
                            }
                        )
                    )
                )
            }
            .bind(to: presentModalVC)
            .disposed(by: priv.disposeBag)
        
        
        input.saveTap
            .filter { LocationManager.shared.requestLocation() }
            .map { [weak self] in
                guard LocationManager.shared.hasMinimumCoordinates else {
                    return ModalViewController(
                        viewModel: ModalViewModel(
                            info: ModalInfo(
                                title: C.info,
                                message: C.minimumPin,
                                submitHandler: {
                                    dismissVC.accept(())
                                    self?.priv.cancelHandler?()
                                }
                            )
                        )
                    )
                }
                
                return ModalViewController(
                    viewModel: ModalViewModel(
                        info: ModalInfo(
                            title: C.warning,
                            message: C.trackingQuitMessage,
                            submitButtonTitle: C.saveTitle,
                            cancelHandler: {
                                dismissVC.accept(())
                                self?.priv.cancelHandler?()
                            },
                            submitHandler: {
                                self?.priv.completeHandler?() //refactor 호출 순서 디버깅
                                FirebaseAnalyticsManager.shared.logEventInScreen(
                                    action: .createTrackingSave,
                                    screen: .createTracking
                                )
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
            dismissVC: dismissVC,
            rootTBC: rootTBC
        )
    }
    
}
