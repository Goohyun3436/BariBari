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
    struct Input {}
    
    //MARK: - Output
    struct Output {
        let navigationTitle: Observable<String>
        let course: BehaviorRelay<Course>
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
        print(course)
    }
    
    //MARK: - Transform
    func transform(input: Input) -> Output {
        let navigationTitle = Observable<String>.just(priv.course.title)
        let course = BehaviorRelay<Course>(value: priv.course)
        
        return Output(
            navigationTitle: navigationTitle,
            course: course
        )
    }
    
}
