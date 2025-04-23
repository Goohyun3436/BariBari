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
        let editTap: ControlEvent<Void>
        let courseTap: ControlEvent<Course>
    }
    
    //MARK: - Output
    struct Output {
        let navigationTitle: BehaviorRelay<String>
        let courses: BehaviorRelay<[Course]>
        let noneContentVisible: BehaviorRelay<Bool>
        let isEditing: BehaviorRelay<Bool>
        let presentModalVC: PublishRelay<BaseViewController>
        let dismissVC: PublishRelay<Void>
        let pushVC: PublishRelay<BaseViewController>
    }
    
    //MARK: - Private
    private struct Private {
        let courseFolder: CourseFolder
        let fetchTrigger = PublishRelay<Void>()
        let updateCourseFolder = PublishRelay<CourseFolder>()
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
        let navigationTitle = BehaviorRelay<String>(value: priv.courseFolder.title)
        let courses = BehaviorRelay<[Course]>(value: [])
        let noneContentVisible = BehaviorRelay<Bool>(value: false)
        let isEditing = BehaviorRelay<Bool>(value: false)
        let presentModalVC = PublishRelay<BaseViewController>()
        let dismissVC = PublishRelay<Void>()
        let pushVC = PublishRelay<BaseViewController>()
        
        let editTap = input.editTap.share(replay: 1)
        
        input.viewWillAppear
            .bind(to: priv.fetchTrigger)
            .disposed(by: priv.disposeBag)
        
        priv.fetchTrigger
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
        
        editTap
            .map { [weak self] _ in
                CreateFolderViewController(
                    viewModel: CreateFolderViewModel(
                        courseFolder: self?.priv.courseFolder,
                        cancelHandler: {
                            dismissVC.accept(())
                        },
                        submitHandler: { courseFolder in
                            navigationTitle.accept(courseFolder.title)
                            dismissVC.accept(())
                        }
                    )
                )
            }
            .bind(to: presentModalVC)
            .disposed(by: priv.disposeBag)
        
        input.courseTap
            .filter { [weak self] _ in self != nil}
            .map { [weak self] course in
                CourseDetailViewController(
                    viewModel: CourseDetailViewModel(
                        courseFolder: self!.priv.courseFolder,
                        course: course
                    )
                )
            }
            .bind(to: pushVC)
            .disposed(by: priv.disposeBag)
        
        editTap
            .map { ActionType.storageCourseFolderEdit }
            .bind(with: self) { owner, action in
                FirebaseAnalyticsManager.shared.logEventInScreen(
                    action: action,
                    screen: .storageCourse
                )
            }
            .disposed(by: priv.disposeBag)
        
        return Output(
            navigationTitle: navigationTitle,
            courses: courses,
            noneContentVisible: noneContentVisible,
            isEditing: isEditing,
            presentModalVC: presentModalVC,
            dismissVC: dismissVC,
            pushVC: pushVC
        )
    }
    
}
