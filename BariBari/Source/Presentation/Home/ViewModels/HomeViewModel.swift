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
    struct Input {
        let viewDidLoad: ControlEvent<Void>
    }
    
    //MARK: - Output
    struct Output {
        let bannerCourse: PublishRelay<Course>
        let courses: BehaviorRelay<[Course]>
    }
    
    //MARK: - Private
    private struct Private {
        let disposeBag = DisposeBag()
    }
    
    //MARK: - Property
    private let priv = Private()
    
    //MARK: - Transform
    func transform(input: Input) -> Output {
        let bannerCourse = PublishRelay<Course>()
        let courses = BehaviorRelay<[Course]>(value: [])
        
        input.viewDidLoad
            .flatMap {
                APIRepository.shared.request(
                    UnplashRequest.search(C.unsplashSearchQuery, perPage: recommendedCourses.count),
                    UnsplashResponse.self,
                    UnsplashErrorResponse.self,
                    UnsplashError.self
                )
            }
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, result in
                switch result {
                case .success(let photos):
                    var coursesWithImage = recommendedCourses
                    
                    photos.results.enumerated().forEach {
                        coursesWithImage[$0.offset].imageUrl = $0.element.urls.small
                    }
                    
                    if let banner = coursesWithImage.first {
                        bannerCourse.accept(banner)
                    }
                    
                    courses.accept(coursesWithImage)
                case .failure(_):
                    bannerCourse.accept(recommendedCourses[0])
                    courses.accept(recommendedCourses)
                }
            }
            .disposed(by: priv.disposeBag)
        
        return Output(
            bannerCourse: bannerCourse,
            courses: courses
        )
    }
    
}
