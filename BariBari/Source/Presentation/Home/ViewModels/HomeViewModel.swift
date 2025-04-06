//
//  HomeViewModel.swift
//  BariBari
//
//  Created by Goo on 4/2/25.
//

import Foundation
import RxSwift
import RxCocoa

final class HomeViewModel: BaseViewModel {
    
    //MARK: - Input
    struct Input {}
    
    //MARK: - Output
    struct Output {
        let bannerCourse: BehaviorRelay<Course>
        let courses: BehaviorRelay<[Course]>
    }
    
    //MARK: - Private
    private struct Private {}
    
    //MARK: - Property
    private let priv = Private()
    
    //MARK: - Transform
    func transform(input: Input) -> Output {
        let bannerCourse = BehaviorRelay<Course>(value: recommendedCourses[0])
        let courses = BehaviorRelay<[Course]>(value: recommendedCourses)
        
        return Output(
            bannerCourse: bannerCourse,
            courses: courses
        )
    }
    
}
