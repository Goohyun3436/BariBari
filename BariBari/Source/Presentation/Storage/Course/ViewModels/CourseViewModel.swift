//
//  CourseViewModel.swift
//  BariBari
//
//  Created by Goo on 4/2/25.
//

import Foundation
import RxSwift
import RxCocoa

final class CourseViewModel: BaseViewModel {
    
    //MARK: - Input
    struct Input {
        let viewWillAppear: ControlEvent<Void>
        let courseTap: ControlEvent<Course>
    }
    
    //MARK: - Output
    struct Output {
        let navigationTitle: Observable<String>
        let courses: BehaviorRelay<[Course]>
        let noneContentVisible: BehaviorRelay<Bool>
        let pushVC: PublishRelay<BaseViewController>
    }
    
    //MARK: - Private
    private struct Private {
        let courseFolder: CourseFolder
        let disposeBag = DisposeBag()
    }
    
    //MARK: - Property
    private let priv: Private
    
    //MARK: - Initializer Method
    init(courseFolder: CourseFolder) {
        priv = Private(courseFolder: courseFolder)
    }
    
    //MARK: - Transform
    func transform(input: Input) -> Output {
        let navigationTitle = Observable<String>.just(priv.courseFolder.title)
        let courses = BehaviorRelay<[Course]>(value: [])
        let noneContentVisible = BehaviorRelay<Bool>(value: false)
        let pushVC = PublishRelay<BaseViewController>()
        
        input.viewWillAppear
            .map { [weak self] _ in
                self?.priv.courseFolder._id
            }
            .filter { $0 != nil }
            .map {
                RealmRepository.shared.fetchCourses(fromFolder: $0!)
            }
            .bind(to: courses)
            .disposed(by: priv.disposeBag)
        
        courses
            .map { !$0.isEmpty }
            .bind(to: noneContentVisible)
            .disposed(by: priv.disposeBag)
        
        input.courseTap
            .map {
                CourseDetailViewController(
                    viewModel: CourseDetailViewModel(course: $0)
                )
            }
            .bind(to: pushVC)
            .disposed(by: priv.disposeBag)
        
        return Output(
            navigationTitle: navigationTitle,
            courses: courses,
            noneContentVisible: noneContentVisible,
            pushVC: pushVC
        )
    }
    
}
