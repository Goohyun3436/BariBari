//
//  EntireCourseViewModel.swift
//  BariBari
//
//  Created by Goo on 4/2/25.
//

import Foundation
import RxSwift
import RxCocoa
import RxGesture

final class EntireCourseViewModel: BaseViewModel {
    
    //MARK: - Input
    struct Input {
        let viewWillAppear: ControlEvent<Void>
        let editTap: ControlEvent<Void>
        let courseFolderLongPress: LongPressControlEvent
        let courseFolderTap: ControlEvent<CourseFolder>
    }
    
    //MARK: - Output
    struct Output {
        let courseFolders: BehaviorRelay<[CourseFolder]>
        let noneContentVisible: BehaviorRelay<Bool>
        let isEditing: BehaviorRelay<Bool>
        let presentModalVC: PublishRelay<BaseViewController>
        let dismissVC: PublishRelay<Void>
        let pushVC: PublishRelay<BaseViewController>
    }
    
    //MARK: - Private
    private struct Private {
        let fetchTrigger = PublishRelay<Void>()
        let deleteCourseFolder = PublishRelay<CourseFolder>()
        let error = PublishRelay<ModalInfo>()
        let disposeBag = DisposeBag()
    }
    
    //MARK: - Property
    private let priv = Private()
    
    //MARK: - Transform
    func transform(input: Input) -> Output {
        let courseFolders = BehaviorRelay<[CourseFolder]>(value: [])
        let noneContentVisible = BehaviorRelay<Bool>(value: false)
        let isEditing = BehaviorRelay<Bool>(value: false)
        let presentModalVC = PublishRelay<BaseViewController>()
        let dismissVC = PublishRelay<Void>()
        let pushVC = PublishRelay<BaseViewController>()
        
        let courseFolderTap = input.courseFolderTap.share(replay: 1)
        
        input.viewWillAppear
            .bind(to: priv.fetchTrigger)
            .disposed(by: priv.disposeBag)
        
        priv.fetchTrigger
            .map {
                RealmRepository.shared.fetchCourseFolders()
            }
            .bind(to: courseFolders)
            .disposed(by: priv.disposeBag)
        
        courseFolders
            .map { !$0.isEmpty }
            .bind(to: noneContentVisible)
            .disposed(by: priv.disposeBag)
        
        input.editTap
            .withLatestFrom(isEditing)
            .map { !$0 }
            .bind(to: isEditing)
            .disposed(by: priv.disposeBag)
        
        input.courseFolderLongPress
            .when(.began)
            .map { _ in true }
            .bind(to: isEditing)
            .disposed(by: priv.disposeBag)
        
        courseFolderTap
            .filter { _ in isEditing.value }
            .map { [weak self] courseFolder in
                ModalViewController(
                    viewModel: ModalViewModel(
                        info: ModalInfo(
                            title: C.warning,
                            message: C.deleteCourseFolderMessage,
                            submitButtonTitle: C.deleteTitle,
                            cancelHandler: {
                                dismissVC.accept(())
                            },
                            submitHandler: {
                                self?.priv.deleteCourseFolder.accept(courseFolder)
                                dismissVC.accept(())
                            }
                        )
                    )
                )
            }
            .bind(to: presentModalVC)
            .disposed(by: priv.disposeBag)
        
        courseFolderTap
            .filter { _ in !isEditing.value }
            .map {
                CourseViewController(
                    viewModel: CourseViewModel(courseFolder: $0)
                )
            }
            .bind(to: pushVC)
            .disposed(by: priv.disposeBag)
        
        priv.deleteCourseFolder
            .filter { $0._id != nil }
            .flatMap {
                RealmRepository.shared.deleteCourseFolder($0._id!)
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success():
                    owner.priv.fetchTrigger.accept(())
                case .failure(let error):
                    owner.priv.error.accept(ModalInfo(title: error.title, message: error.message))
                }
            }
            .disposed(by: priv.disposeBag)
        
        priv.error
            .map {
                ModalViewController(
                    viewModel: ModalViewModel(
                        info: ModalInfo(
                            title: $0.title,
                            message: $0.message,
                            submitHandler: { dismissVC.accept(()) }
                        )
                    )
                )
            }
            .bind(to: presentModalVC)
            .disposed(by: priv.disposeBag)
            
        return Output(
            courseFolders: courseFolders,
            noneContentVisible: noneContentVisible,
            isEditing: isEditing,
            presentModalVC: presentModalVC,
            dismissVC: dismissVC,
            pushVC: pushVC
        )
    }
    
}
