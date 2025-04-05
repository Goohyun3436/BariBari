//
//  CourseDetailViewModel.swift
//  BariBari
//
//  Created by Goo on 4/2/25.
//

import Foundation
import RxSwift
import RxCocoa

final class CourseDetailViewModel: BaseViewModel {
    
    //MARK: - Input
    struct Input {
        let mapButtonTap: ControlEvent<Void>
    }
    
    //MARK: - Output
    struct Output {
        let navigationTitle: Observable<String>
        let course: BehaviorRelay<Course>
        let presentVC: PublishRelay<(vc: BaseViewController, detents: CGFloat)>
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
        let navigationTitle = Observable<String>.just(priv.course.title)
        let course = BehaviorRelay<Course>(value: priv.course)
        let presentVC = PublishRelay<(vc: BaseViewController, detents: CGFloat)>()
        
        input.mapButtonTap
            .withUnretained(self)
            .map { $0.0 }
            .map { owner in
                let vc = MapPickerViewController(
                    viewModel: MapPickerViewModel(
                        pins: owner.priv.course.pins
                    )
                )
                return (vc: vc, detents: C.presentBottomDetents)
            }
            .bind(to: presentVC)
            .disposed(by: priv.disposeBag)
        
        return Output(
            navigationTitle: navigationTitle,
            course: course,
            presentVC: presentVC
        )
    }
    
}
