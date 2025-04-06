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
        let image: PublishRelay<[PHPickerResult]>
        let title: ControlProperty<String?>
        let imageTap:  ControlEvent<RxGestureRecognizer>
        let cancelTap: ControlEvent<Void>
        let saveTap: ControlEvent<Void>
    }
    
    //MARK: - Output
    struct Output {
        let image: PublishRelay<UIImage>
        let presentImagePickerVC: PublishRelay<Void>
        let presentModalVC: PublishRelay<BaseViewController>
        let dismissVC: PublishRelay<Void>
    }
    
    //MARK: - Private
    private struct Private {
        let cancelHandler: () -> Void
        let saveHandler: (CourseFolder) -> Void
        let courseFolder = PublishRelay<CourseFolder>()
        let courseFolderImage = BehaviorRelay<Data?>(value: nil)
        let error = PublishRelay<ModalInfo>()
        let disposeBag = DisposeBag()
    }
    
    //MARK: - Property
    private let priv: Private
    
    init(
        cancelHandler: @escaping () -> Void,
        saveHandler: @escaping (CourseFolder) -> Void
    ) {
        priv = Private(
            cancelHandler: cancelHandler,
            saveHandler: saveHandler
        )
    }
    
    //MARK: - Transform
    func transform(input: Input) -> Output {
        let image = PublishRelay<UIImage>()
        let presentImagePickerVC = PublishRelay<Void>()
        let presentModalVC = PublishRelay<BaseViewController>()
        let dismissVC = PublishRelay<Void>()
        
        input.imageTap
            .when(.recognized)
            .map { _ in }
            .bind(to: presentImagePickerVC)
            .disposed(by: priv.disposeBag)
        
        input.image
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
                    owner.priv.error.accept(ModalInfo(title: error.title, message: error.message))
                }
            }
            .disposed(by: priv.disposeBag)
        
        input.cancelTap
            .bind(with: self) { owner, _ in
                owner.priv.cancelHandler()
            }
            .disposed(by: priv.disposeBag)
        
        input.saveTap
            .withLatestFrom(
                Observable.combineLatest(
                    input.title,
                    self.priv.courseFolderImage
                )
            )
            .flatMap {
                CreateCourseFolderError.validation(title: $0.0, image: $0.1)
            }
            .bind(with: self, onNext: { owner, result in
                switch result {
                case .success(let courseFolder):
                    owner.priv.courseFolder.accept(courseFolder)
                case .failure(let error):
                    dump(error)
                }
            })
            .disposed(by: priv.disposeBag)
        
        priv.courseFolder
            .flatMap {
                RealmRepository.shared.addCourseFolder($0)
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let courseFolder):
                    owner.priv.saveHandler(courseFolder)
                case .failure(let error):
                    dump(error)
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
            image: image,
            presentImagePickerVC: presentImagePickerVC,
            presentModalVC: presentModalVC,
            dismissVC: dismissVC
        )
    }
    
}
