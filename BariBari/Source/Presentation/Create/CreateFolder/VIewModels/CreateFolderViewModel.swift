//
//  CreateFolderViewModel.swift
//  BariBari
//
//  Created by Goo on 4/4/25.
//

import Foundation
import PhotosUI
import MapKit
import RxSwift
import RxCocoa
import RxGesture

final class CreateFolderViewModel: BaseViewModel {
    
    //MARK: - Input
    struct Input {
        let viewWillAppear: ControlEvent<Void>
        let image: PublishRelay<[PHPickerResult]>
        let title: ControlProperty<String?>
        let imageTap:  ControlEvent<RxGestureRecognizer>
        let cancelTap: ControlEvent<Void>
        let submitTap: ControlEvent<Void>
    }
    
    //MARK: - Output
    struct Output {
        let modalTitle: Observable<String>
        let submitTitle: Observable<String>
        let image: PublishRelay<UIImage>
        let title: PublishRelay<String>
        let presentImagePickerVC: PublishRelay<Void>
        let presentModalVC: PublishRelay<BaseViewController>
        let dismissVC: PublishRelay<Void>
    }
    
    //MARK: - Private
    private struct Private {
        let inputCurseFolder: CourseFolder?
        let modalTitle: String
        let submitTitle: String
        let cancelHandler: () -> Void
        let submitHandler: (CourseFolder) -> Void
        let courseFolder = PublishRelay<CourseFolder>()
        let courseFolderTitle = BehaviorRelay<String?>(value: nil)
        let courseFolderImage = BehaviorRelay<Data?>(value: nil)
        let error = PublishRelay<AppError>()
        let disposeBag = DisposeBag()
    }
    
    //MARK: - Property
    private let priv: Private
    
    init(
        courseFolder: CourseFolder? = nil,
        cancelHandler: @escaping () -> Void,
        submitHandler: @escaping (CourseFolder) -> Void
    ) {
        priv = Private(
            inputCurseFolder: courseFolder,
            modalTitle: courseFolder == nil ? C.courseFolderCreateTitle : C.courseFolderUpdateTitle,
            submitTitle: courseFolder == nil ? C.saveTitle : C.updateTitle,
            cancelHandler: cancelHandler,
            submitHandler: submitHandler
        )
    }
    
    //MARK: - Transform
    func transform(input: Input) -> Output {
        let modalTitle = Observable<String>.just(priv.modalTitle)
        let submitTitle = Observable<String>.just(priv.submitTitle)
        let image = PublishRelay<UIImage>()
        let title = PublishRelay<String>()
        let presentImagePickerVC = PublishRelay<Void>()
        let presentModalVC = PublishRelay<BaseViewController>()
        let dismissVC = PublishRelay<Void>()
        
        let courseFolder = priv.courseFolder.share(replay: 1)
        
        input.viewWillAppear
            .bind(with: self) { owner, _ in
                guard let courseFolder = owner.priv.inputCurseFolder
                else { return }
                
                if let imageData = courseFolder.image,
                   let inputImage = UIImage(data: imageData) {
                    owner.priv.courseFolderImage.accept(imageData)
                    image.accept(inputImage)
                }
                
                owner.priv.courseFolderTitle.accept(courseFolder.title)
                title.accept(courseFolder.title)
            }
            .disposed(by: priv.disposeBag)
        
        input.title
            .bind(to: priv.courseFolderTitle)
            .disposed(by: priv.disposeBag)
        
        input.imageTap
            .when(.recognized)
            .map { _ in }
            .bind(to: presentImagePickerVC)
            .disposed(by: priv.disposeBag)
        
        input.image
            .filter { !$0.isEmpty }
            .flatMap {
                ImageManager.shared.convertPHPicker(with: $0)
            }
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, result in
                switch result {
                case .success((let selectedImage, let imageData)):
                    image.accept(selectedImage)
                    owner.priv.courseFolderImage.accept(imageData)
                case .failure(let error):
                    owner.priv.error.accept(error)
                }
            }
            .disposed(by: priv.disposeBag)
        
        input.cancelTap
            .bind(with: self) { owner, _ in
                owner.priv.cancelHandler()
            }
            .disposed(by: priv.disposeBag)
        
        input.submitTap
            .withLatestFrom(
                Observable.combineLatest(
                    self.priv.courseFolderTitle,
                    self.priv.courseFolderImage
                )
            )
            .flatMap {
                CreateCourseFolderError.validation(
                    _id: self.priv.inputCurseFolder?._id,
                    title: $0.0,
                    image: $0.1
                )
            }
            .bind(with: self, onNext: { owner, result in
                switch result {
                case .success(let courseFolder):
                    owner.priv.courseFolder.accept(courseFolder)
                case .failure(let error):
                    owner.priv.error.accept(error)
                }
            })
            .disposed(by: priv.disposeBag)
        
        courseFolder
            .filter { [weak self] _ in self?.priv.inputCurseFolder == nil }
            .flatMap {
                RealmRepository.shared.addCourseFolder($0)
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let courseFolder):
                    owner.priv.submitHandler(courseFolder)
                case .failure(let error):
                    owner.priv.error.accept(error)
                }
            }
            .disposed(by: priv.disposeBag)
        
        courseFolder
            .filter { [weak self] _ in self?.priv.inputCurseFolder != nil }
            .flatMap {
                RealmRepository.shared.updateCourseFolder($0)
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let courseFolder):
                    owner.priv.submitHandler(courseFolder)
                case .failure(let error):
                    owner.priv.error.accept(error)
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
            modalTitle: modalTitle,
            submitTitle: submitTitle,
            image: image,
            title: title,
            presentImagePickerVC: presentImagePickerVC,
            presentModalVC: presentModalVC,
            dismissVC: dismissVC
        )
    }
    
}
