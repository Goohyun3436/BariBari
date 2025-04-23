//
//  MapPickerViewModel.swift
//  BariBari
//
//  Created by Goo on 4/5/25.
//

import Foundation
import RxSwift
import RxCocoa

final class MapPickerViewModel: BaseViewModel {
    
    //MARK: - Input
    struct Input {
        let naverMapTap: ControlEvent<Void>
    }
    
    //MARK: - Output
    struct Output {}
    
    //MARK: - Private
    private struct Private {
        let pins: [Pin]
        let disposeBag = DisposeBag()
    }
    
    //MARK: - Property
    private let priv: Private
    
    //MARK: - Initializer Method
    init(pins: [Pin]) {
        priv = Private(pins: pins)
    }
    
    //MARK: - Transform
    func transform(input: Input) -> Output {
        let naverMapTap = input.naverMapTap.share(replay: 1)
        
        naverMapTap
            .bind(with: self) { owner, _ in
                MapManager.shared.openNaverMap(pins: owner.priv.pins)
            }
            .disposed(by: priv.disposeBag)
        
        naverMapTap
            .map { ActionType.openNaverMap }
            .bind(with: self) { owner, action in
                FirebaseAnalyticsManager.shared.logEventInScreen(
                    action: action,
                    screen: .courseDetailMapPicker
                )
            }
            .disposed(by: priv.disposeBag)
        
        return Output()
    }
    
}
