//
//  HomeViewModel.swift
//  BariBari
//
//  Created by Goo on 4/2/25.
//

import Foundation
import RxSwift
import RxCocoa
import RxGesture

final class HomeViewModel: BaseViewModel {
    
    //MARK: - Input
    struct Input {
        let viewDidLoad: ControlEvent<Void>
        let moreTap: ControlEvent<Void>
        let bannerTap: ControlEvent<RxGestureRecognizer>
        let courseTap: ControlEvent<Course>
    }
    
    //MARK: - Output
    struct Output {
        let bannerCourse: PublishRelay<Course>
        let courses: BehaviorRelay<[Course]>
        let presentActionSheet: PublishRelay<[ActionSheetInfo]>
        let presentVC: PublishRelay<BaseViewController>
        let pushVC: PublishRelay<BaseViewController>
    }
    
    //MARK: - Private
    private struct Private {
        let selectedCourse = PublishRelay<Course>()
        let disposeBag = DisposeBag()
    }
    
    //MARK: - Property
    private let priv = Private()
    
    //MARK: - Transform
    func transform(input: Input) -> Output {
        let bannerCourse = PublishRelay<Course>()
        let courses = BehaviorRelay<[Course]>(value: [])
        let presentActionSheet = PublishRelay<[ActionSheetInfo]>()
        let presentVC = PublishRelay<BaseViewController>()
        let pushVC = PublishRelay<BaseViewController>()
        
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
            .bind(with: self) { owner, response in
                switch response {
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
        
        input.moreTap
            .map {[
                ActionSheetInfo(title: C.aboutTitle) { presentVC.accept(AboutViewController()) }
            ]}
            .bind(to: presentActionSheet)
            .disposed(by: priv.disposeBag)
        
        input.bannerTap
            .when(.recognized)
            .withLatestFrom(courses)
            .filter { $0.first != nil }
            .map { $0.first! }
            .bind(to: priv.selectedCourse)
            .disposed(by: priv.disposeBag)
        
        input.courseTap
            .bind(to: priv.selectedCourse)
            .disposed(by: priv.disposeBag)
        
        priv.selectedCourse
            .map {
                HomeDetailViewController(
                    viewModel: HomeDetailViewModel(course: $0)
                )
            }
            .bind(to: pushVC)
            .disposed(by: priv.disposeBag)
        
        return Output(
            bannerCourse: bannerCourse,
            courses: courses,
            presentActionSheet: presentActionSheet,
            presentVC: presentVC,
            pushVC: pushVC
        )
    }
    
}
