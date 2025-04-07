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
        let viewDidLoad: ControlEvent<Void>
        let editTap: ControlEvent<Void>
        let deleteTap: ControlEvent<Void>
        let mapButtonTap: ControlEvent<Void>
    }
    
    //MARK: - Output
    struct Output {
        let navigationTitle: BehaviorRelay<String>
        let course: BehaviorRelay<Course>
        let isEditing: BehaviorRelay<Bool>
        let presentVC: PublishRelay<(vc: BaseViewController, detents: CGFloat)>
        let presentFormVC: PublishRelay<BaseViewController>
        let presentModalVC: PublishRelay<BaseViewController>
        let dismissVC: PublishRelay<Void>
        let popVC: PublishRelay<Void>
    }
    
    //MARK: - Private
    private struct Private {
        let courseFolder: CourseFolder
        var course: Course
        let fetchTrigger = PublishRelay<Void>()
        let deleteCourse = PublishRelay<Course>()
        let error = PublishRelay<AppError>()
        let disposeBag = DisposeBag()
    }
    
    //MARK: - Property
    private var priv: Private
    
    //MARK: - Initializer Method
    init(courseFolder: CourseFolder, course: Course) {
        priv = Private(courseFolder: courseFolder, course: course)
    }
    
    //MARK: - Transform
    func transform(input: Input) -> Output {
        let navigationTitle = BehaviorRelay<String>(value: priv.course.title)
        let course = BehaviorRelay<Course>(value: priv.course)
        let isEditing = BehaviorRelay<Bool>(value: false)
        let presentVC = PublishRelay<(vc: BaseViewController, detents: CGFloat)>()
        let presentFormVC = PublishRelay<BaseViewController>()
        let presentModalVC = PublishRelay<BaseViewController>()
        let dismissVC = PublishRelay<Void>()
        let popVC = PublishRelay<Void>()
        
        let editTap = input.editTap.share(replay: 1)
        
        input.viewDidLoad
            .bind(with: self) { owner, _ in
                _ = LocationManager.shared.requestLocation()
            }
            .disposed(by: priv.disposeBag)
        
        priv.fetchTrigger
            .filter { [weak self] _ in self?.priv.course._id != nil }
            .flatMap { [weak self] _ in
                RealmRepository.shared.fetchCourse(self!.priv.course._id!)
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let course_):
                    navigationTitle.accept(course_.title)
                    course.accept(course_)
                    owner.priv.course = course_
                case .failure(let error):
                    owner.priv.error.accept(error)
                }
            }
            .disposed(by: priv.disposeBag)
        
        editTap
            .map { true }
            .bind(to: isEditing)
            .disposed(by: priv.disposeBag)
        
        editTap
            .filter { [weak self] _ in self != nil }
            .map { [weak self] _ in
                CreateFormViewController(
                    viewModel: CreateFormViewModel(
                        course: self!.priv.course,
                        pins: self!.priv.course.pins,
                        cancelHander: {
                            dismissVC.accept(())
                            isEditing.accept(false)
                        },
                        submitHander: { course in
                            dismissVC.accept(())
                            isEditing.accept(false)
                            
                            self?.priv.fetchTrigger.accept(())
                            
                            if self?.priv.course.folder?._id != course.folder?._id {
                                self?.priv.error.accept(FetchCourseError.moveCourseFolder)
                            }
                        }
                    )
                )
            }
            .bind(to: presentFormVC)
            .disposed(by: priv.disposeBag)
        
        input.deleteTap
            .map { [weak self] _ in
                ModalViewController(
                    viewModel: ModalViewModel(
                        info: ModalInfo(
                            title: C.warning,
                            message: C.deleteCourseMessage,
                            submitButtonTitle: C.deleteTitle,
                            cancelHandler: {
                                dismissVC.accept(())
                            },
                            submitHandler: {
                                guard let course = self?.priv.course else { return }
                                self?.priv.deleteCourse.accept(course)
                            }
                        )
                    )
                )
            }
            .bind(to: presentModalVC)
            .disposed(by: priv.disposeBag)
        
        priv.deleteCourse
            .filter { $0._id != nil }
            .flatMap {
                RealmRepository.shared.deleteCourse($0._id!)
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success():
                    dismissVC.accept(())
                    presentModalVC.accept(ModalViewController(
                        viewModel: ModalViewModel(
                            info: ModalInfo(
                                title: C.deleteTitle,
                                message: C.deleteCourseConfirmMessage,
                                submitHandler: {
                                    dismissVC.accept(())
                                    popVC.accept(())
                                }
                            )
                        )
                    ))
                case .failure(let error):
                    dismissVC.accept(())
                    owner.priv.error.accept(error)
                }
            }
            .disposed(by: priv.disposeBag)
        
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
        
        priv.error
            .map { error in
                ModalViewController(
                    viewModel: ModalViewModel(
                        info: ModalInfo(
                            title: error.title,
                            message: error.message,
                            submitHandler: {
                                dismissVC.accept(())
                                
                                if error is FetchCourseError {
                                    popVC.accept(())
                                }
                            }
                        )
                    )
                )
            }
            .bind(to: presentModalVC)
            .disposed(by: priv.disposeBag)
        
        return Output(
            navigationTitle: navigationTitle,
            course: course,
            isEditing: isEditing,
            presentVC: presentVC,
            presentFormVC: presentFormVC,
            presentModalVC: presentModalVC,
            dismissVC: dismissVC,
            popVC: popVC
        )
    }
    
}
