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
    struct Output {}
    
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
        return Output()
    }
    
}
