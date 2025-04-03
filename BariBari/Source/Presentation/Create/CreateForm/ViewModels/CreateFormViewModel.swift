//
//  CreateFormViewModel.swift
//  BariBari
//
//  Created by Goo on 4/2/25.
//

import Foundation
import MapKit
import RxSwift
import RxCocoa

final class CreateFormViewModel: BaseViewModel {
    
    //MARK: - Input
    struct Input {
        let title: ControlProperty<String?>
        let content: ControlProperty<String?>
//        let image:
        let quitTap: ControlEvent<Void>
        let saveTap: ControlEvent<Void>
    }
    
    //MARK: - Output
    struct Output {
        let presentModalVC: PublishRelay<BaseViewController>
        let dismissVC: PublishRelay<Void>
        let rootTBC: PublishRelay<Void>
    }
    
    deinit {
        print(self, #function)
    }
    
    //MARK: - Private
    private struct Private {
        let coords: [CLLocationCoordinate2D]
        let disposeBag = DisposeBag()
    }
    
    //MARK: - Property
    private let priv: Private
    
    init(coords: [CLLocationCoordinate2D]) {
        priv = Private(coords: coords)
    }
    
    //MARK: - Transform
    func transform(input: Input) -> Output {
        let presentModalVC = PublishRelay<BaseViewController>()
        let dismissVC = PublishRelay<Void>()
        let rootTBC = PublishRelay<Void>()
        
        input.quitTap
            .map {
                ModalViewController(
                    viewModel: ModalViewModel(
                        info: ModalInfo(
                            title: "경고",
                            message: "코스 추적 기록을 종료하시겠습니까?\n해당 추적 내역이 저장되지 않으며,\n되돌릴 수 없습니다.",
                            cancelHandler: { dismissVC.accept(()) },
                            submitHandler: { rootTBC.accept(()) }
                        )
                    )
                )
            }
            .bind(to: presentModalVC)
            .disposed(by: priv.disposeBag)
        
        input.saveTap
            .map { [weak self] _ in
                print(input.title)
                print(input.content)
                print(self?.priv.coords)
            }
            .bind(to: rootTBC)
            .disposed(by: priv.disposeBag)
        
        return Output(
            presentModalVC: presentModalVC,
            dismissVC: dismissVC,
            rootTBC: rootTBC
        )
    }
    
}
