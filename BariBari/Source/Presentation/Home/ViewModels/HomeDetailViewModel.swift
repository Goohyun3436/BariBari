//
//  HomeDetailViewModel.swift
//  BariBari
//
//  Created by Goo on 4/2/25.
//

import Foundation
import RxSwift
import RxCocoa

final class HomeDetailViewModel: BaseViewModel {
    
    //MARK: - Input
    struct Input {
        let viewDidLoad: ControlEvent<Void>
        let mapButtonTap: ControlEvent<Void>
    }
    
    //MARK: - Output
    struct Output {
        let navigationTitle: BehaviorRelay<String>
        let course: BehaviorRelay<Course>
        let presentVC: PublishRelay<(vc: BaseViewController, detents: CGFloat)>
        let dismissVC: PublishRelay<Void>
    }
    
    //MARK: - Private
    private struct Private {
        let course: Course
        let disposeBag = DisposeBag()
    }
    
    //MARK: - Property
    private let priv: Private
    
    //MARK: - Initializer Method
    init(course: Course) {
        priv = Private(course: course)
    }
    
    //MARK: - Transform
    func transform(input: Input) -> Output {
        let navigationTitle = BehaviorRelay<String>(value: priv.course.title)
        let course = BehaviorRelay<Course>(value: priv.course)
        let presentVC = PublishRelay<(vc: BaseViewController, detents: CGFloat)>()
        let dismissVC = PublishRelay<Void>()
        
        let mapButtonTap = input.mapButtonTap.share(replay: 1)
        
        input.viewDidLoad
            .bind(with: self) { owner, _ in
                _ = LocationManager.shared.requestLocation()
            }
            .disposed(by: priv.disposeBag)
        
        mapButtonTap
            .withUnretained(self)
            .map { $0.0 }
            .map { owner in
                let vc = MapPickerViewController(
                    viewModel: MapPickerViewModel(
                        pins: owner.priv.course.directionPins
                    )
                )
                return (vc: vc, detents: C.presentBottomDetents)
            }
            .bind(to: presentVC)
            .disposed(by: priv.disposeBag)
        
        mapButtonTap
            .map { ActionType.homeDetailMap }
            .bind(with: self) { owner, action in
                FirebaseAnalyticsManager.shared.logEventInScreen(
                    action: action,
                    screen: .homeDetail
                )
            }
            .disposed(by: priv.disposeBag)
        
        return Output(
            navigationTitle: navigationTitle,
            course: course,
            presentVC: presentVC,
            dismissVC: dismissVC
        )
    }
    
}
