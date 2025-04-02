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
        let cancelTap: ControlEvent<Void>
        let submitTap: ControlEvent<Void>
    }
    
    //MARK: - Output
    struct Output {
        let presentVC: PublishRelay<BaseViewController>
        let dismissVC: PublishRelay<Void>
    }
    
    //MARK: - Private
    private struct Private {
        let coords: [CLLocationCoordinate2D]
        let cancelHandler: (() -> Void)?
        let disposeBag = DisposeBag()
    }
    
    //MARK: - Property
    private let priv: Private
    
    init(coords: [CLLocationCoordinate2D] ,cancelHandler: (() -> Void)?) {
        priv = Private(coords: coords, cancelHandler: cancelHandler)
    }
    
    //MARK: - Transform
    func transform(input: Input) -> Output {
        let presentVC = PublishRelay<BaseViewController>()
        let dismissVC = PublishRelay<Void>()
        
        
        
        return Output(
            presentVC: presentVC,
            dismissVC: dismissVC
        )
    }
    
}
