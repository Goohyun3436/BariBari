//
//  CreateFormViewModel.swift
//  BariBari
//
//  Created by Goo on 4/2/25.
//

import Foundation
import PhotosUI
import MapKit
import RxSwift
import RxCocoa
import RxGesture

final class CreateFormViewModel: BaseViewModel {
    
    //MARK: - Input
    struct Input {
        let viewWillAppear: ControlEvent<Void>
        let image: PublishRelay<[PHPickerResult]>
        let title: ControlProperty<String?>
        let content: ControlProperty<String?>
        let imageTap:  ControlEvent<RxGestureRecognizer>
        let quitTap: ControlEvent<Void>
        let saveTap: ControlEvent<Void>
    }
    
    //MARK: - Output
    struct Output {
        let courseFolderPickerItems: PublishRelay<(
            items: [CourseFolder],
            createFolderHandler: (() -> Void)?,
            completionHandler: ((CourseFolder) -> Void)?
        )>
        let courseFolderTitle: PublishRelay<String?>
        let image: PublishRelay<UIImage>
        let title: PublishRelay<String?>
        let content: PublishRelay<String?>
        let presentImagePickerVC: PublishRelay<Void>
        let presentModalVC: PublishRelay<BaseViewController>
        let dismissVC: PublishRelay<Void>
        let rootTBC: PublishRelay<Void>
    }
    
    //MARK: - Private
    private struct Private {
        var inputCourse: Course?
        let pins: [Pin]
        var isInitial: Bool = true
        let cancelHander: (() -> Void)?
        let submitHander: ((Course) -> Void)?
        let fetchCourseFoldersTrigger = PublishRelay<Void>()
        let createTemporaryCourseFolderTrigger = PublishRelay<Void>()
        let courseFolders = BehaviorRelay<[CourseFolder]>(value: [])
        let courseFolder = BehaviorRelay<CourseFolder?>(value: nil)
        let courseImage = BehaviorRelay<Data?>(value: nil)
        let courseTitle = BehaviorRelay<String?>(value: nil)
        let courseContent = BehaviorRelay<String?>(value: nil)
        let pendingCourse = BehaviorRelay<Course?>(value: nil)
        let course = PublishRelay<Course>()
        let error = PublishRelay<AppError>()
        let disposeBag = DisposeBag()
    }
    
    //MARK: - Property
    private var priv: Private
    
    init(
        course: Course? = nil,
        pins: [Pin],
        cancelHander: (() -> Void)? = nil,
        submitHander: ((Course) -> Void)? = nil
    ) {
        priv = Private(
            inputCourse: course,
            pins: pins,
            cancelHander: cancelHander,
            submitHander: submitHander
        )
    }
    
    //MARK: - Transform
    func transform(input: Input) -> Output {
        let courseFolderPickerItems = PublishRelay<(
            items: [CourseFolder],
            createFolderHandler: (() -> Void)?,
            completionHandler: ((CourseFolder) -> Void)?
        )>()
        let courseFolderTitle = PublishRelay<String?>()
        let image = PublishRelay<UIImage>()
        let title = PublishRelay<String?>()
        let content = PublishRelay<String?>()
        let presentImagePickerVC = PublishRelay<Void>()
        let presentModalVC = PublishRelay<BaseViewController>()
        let dismissVC = PublishRelay<Void>()
        let rootTBC = PublishRelay<Void>()
        
        let viewWillAppear = input.viewWillAppear.share(replay: 1)
        let courseFolders = priv.courseFolders.share(replay: 1)
        let courseFolder = priv.courseFolder.share(replay: 1)
        let pendingCourse = priv.pendingCourse.share(replay: 1)
        let quitTap = input.quitTap.share(replay: 1)
        let saveTap = input.saveTap.share(replay: 1)
        let imageTap = input.imageTap.when(.recognized).share(replay: 1)
        
        viewWillAppear
            .bind(to: priv.fetchCourseFoldersTrigger)
            .disposed(by: priv.disposeBag)
        
        viewWillAppear
            .bind(with: self) { owner, _ in
                guard let inputCourse = owner.priv.inputCourse else { return }
                
                if let imageData = inputCourse.image,
                   let inputImage = UIImage(data: imageData) {
                    owner.priv.courseImage.accept(imageData)
                    image.accept(inputImage)
                }
                
                owner.priv.courseTitle.accept(inputCourse.title)
                owner.priv.courseContent.accept(inputCourse.content)
                title.accept(inputCourse.title)
                content.accept(inputCourse.content)
                owner.priv.isInitial = false
            }
            .disposed(by: priv.disposeBag)
        
        priv.fetchCourseFoldersTrigger
            .map {
                RealmRepository.shared.fetchCourseFolders()
            }
            .map { [weak self] courseFolders in
                guard let isInitial = self?.priv.isInitial, isInitial,
                      let targetId = self?.priv.inputCourse?.folder?._id
                else {
                    return courseFolders
                }
                
                var updatedFolders = courseFolders
                
                if let index = updatedFolders.firstIndex(where: { $0._id == targetId }) {
                    let targetFolder = updatedFolders.remove(at: index)
                    updatedFolders.insert(targetFolder, at: 0)
                }
                
                return updatedFolders
            }
            .bind(to: priv.courseFolders)
            .disposed(by: priv.disposeBag)
        
        courseFolders
            .map { [weak self] courseFolders in
                (
                    items: courseFolders,
                    createFolderHandler: {
                        presentModalVC.accept(CreateFolderViewController(
                            viewModel: CreateFolderViewModel(
                                cancelHandler: {
                                    self?.priv.courseFolder.accept(nil)
                                    dismissVC.accept(())
                                },
                                submitHandler: { courseFolder in
                                    self?.priv.fetchCourseFoldersTrigger.accept(())
                                    dismissVC.accept(())
                                }
                            )
                        ))
                    },
                    completionHandler: { courseFolder in
                        self?.priv.courseFolder.accept(courseFolder)
                    }
                )
            }
            .bind(to: courseFolderPickerItems)
            .disposed(by: priv.disposeBag)
        
        courseFolders
            .map { [weak self] courseFolders in
                guard let isInitial = self?.priv.isInitial, isInitial,
                      let folder = self?.priv.inputCourse?.folder
                else {
                    return courseFolders.first
                }
                
                return folder
            }
            .bind(to: priv.courseFolder)
            .disposed(by: priv.disposeBag)
        
        courseFolder
            .filter { $0 == nil }
            .map { _ in C.courseFolderPickerTitle }
            .bind(to: courseFolderTitle)
            .disposed(by: priv.disposeBag)
        
        imageTap
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
                    owner.priv.courseImage.accept(imageData)
                case .failure(let error):
                    owner.priv.error.accept(error)
                }
            }
            .disposed(by: priv.disposeBag)
        
        input.title
            .bind(to: priv.courseTitle)
            .disposed(by: priv.disposeBag)
        
        input.content
            .bind(to: priv.courseContent)
            .disposed(by: priv.disposeBag)
        
        quitTap
            .filter { self.priv.inputCourse == nil }
            .map {
                ModalViewController(
                    viewModel: ModalViewModel(
                        info: ModalInfo(
                            title: C.warning,
                            message: C.createFormQuitMessage,
                            submitButtonTitle: C.quitTitle,
                            cancelHandler: { dismissVC.accept(()) },
                            submitHandler: {
                                FirebaseAnalyticsManager.shared.logEventInScreen(
                                    action: .createFormQuit,
                                    screen: .createForm
                                )
                                rootTBC.accept(())
                            }
                        )
                    )
                )
            }
            .bind(to: presentModalVC)
            .disposed(by: priv.disposeBag)
        
        quitTap
            .filter { [weak self] _ in self?.priv.inputCourse != nil }
            .map { [weak self] _ in
                ModalViewController(
                    viewModel: ModalViewModel(
                        info: ModalInfo(
                            title: C.warning,
                            message: C.updateFormQuitMessage,
                            submitButtonTitle: C.quitTitle,
                            cancelHandler: { dismissVC.accept(()) },
                            submitHandler: {
                                dismissVC.accept(())
                                self?.priv.cancelHander?()
                            }
                        )
                    )
                )
            }
            .bind(to: presentModalVC)
            .disposed(by: priv.disposeBag)
        
        saveTap
            .withLatestFrom(
                Observable.combineLatest(
                    self.priv.courseFolder,
                    self.priv.courseImage,
                    self.priv.courseTitle,
                    self.priv.courseContent
                )
            )
            .flatMap { [weak self] in
                CreateCourseError.validation(
                    _id: self?.priv.inputCourse?._id,
                    courseFolder: $0.0,
                    image: $0.1,
                    title: $0.2,
                    content: $0.3,
                    pins: self?.priv.pins
                )
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success(var course):
                    if owner.priv.inputCourse == nil {
                        course.pins[0].address = C.startPinTitle
                        course.pins[course.pins.count - 1].address = C.destinationPinTitle
                    }
                    owner.priv.pendingCourse.accept(course)
                case .failure(let error):
                    switch error {
                    case .emptyCourseFolder:
                        presentModalVC.accept(ModalViewController(
                            viewModel: ModalViewModel(
                                info: ModalInfo(
                                    title: error.title,
                                    message: error.message,
                                    cancelButtonTitle: C.submitTitle,
                                    submitButtonTitle: C.createTemporaryCourseFolderTitle,
                                    cancelHandler: {
                                        dismissVC.accept(())
                                    },
                                    submitHandler: {
                                        owner.priv.createTemporaryCourseFolderTrigger.accept(())
                                    }
                                )
                            )
                        ))
                    default:
                        owner.priv.error.accept(error)
                    }
                }
            }
            .disposed(by: priv.disposeBag)
        
        priv.createTemporaryCourseFolderTrigger
            .flatMap {
                RealmRepository.shared.addTemporaryCourseFolder()
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success(_):
                    owner.priv.fetchCourseFoldersTrigger.accept(())
                    dismissVC.accept(())
                case .failure(let error):
                    dismissVC.accept(())
                    owner.priv.error.accept(error)
                }
            }
            .disposed(by: priv.disposeBag)
        
        pendingCourse
            .bind(with: self) { owner, course in
                title.accept(course?.title)
                content.accept(course?.content)
            }
            .disposed(by: priv.disposeBag)
        
        pendingCourse
            .filter { [weak self] course in
                self?.priv.inputCourse == nil && course != nil
            }
            .map {
                $0!.directionPins.compactMap { pin -> APIRequest? in
                    guard let coord = pin.coord else { return nil }
                    return NMapRequest.reverseGeocode(coord)
                }
            }
            .flatMapLatest {
                APIRepository.shared.requestMultiple(
                    $0,
                    NMapResponseDTO.self,
                    NMapStatus.self,
                    NMapError.self
                )
            }
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, response in
                switch response {
                case .success(let data):
                    guard var pendingCourse = owner.priv.pendingCourse.value else {
                        owner.priv.error.accept(NMapError.unknown)
                        return
                    }
                    
                    var directionPins = [Pin]()
                    
                    data.enumerated().forEach {
                        if let pin = $0.element.transform(with: pendingCourse.directionPins[$0.offset]) {
                            directionPins.append(pin)
                        }
                    }
                    
                    
                    guard pendingCourse.directionPins.count == directionPins.count,
                          let destinationPin = directionPins.last,
                          let zone = destinationPin.zone
                    else {
                        owner.priv.error.accept(NMapError.unknown)
                        return
                    }
                    
                    pendingCourse.destinationPin = destinationPin
                    pendingCourse.zone = zone
                    pendingCourse.directionPins = directionPins
                    owner.priv.course.accept(pendingCourse)
                case .failure(let error):
                    owner.priv.error.accept(error)
                }
            })
            .disposed(by: priv.disposeBag)
        
        pendingCourse
            .filter { [weak self] course in
                self?.priv.inputCourse != nil && course != nil
            }
            .map { $0! }
            .bind(to: priv.course)
            .disposed(by: priv.disposeBag)
        
        priv.course
            .filter { [weak self] _ in self?.priv.inputCourse == nil }
            .withLatestFrom(priv.courseFolder) { (course: $0, folderId: $1?._id) }
            .filter { $0.folderId != nil }
            .flatMap {
                RealmRepository.shared.addCourse($0.course, toFolder: $0.folderId!)
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success(_):
                    presentModalVC.accept(ModalViewController(
                        viewModel: ModalViewModel(
                            info: ModalInfo(
                                title: C.saveTitle,
                                message: C.saveCourseMessage,
                                submitHandler: {
                                    rootTBC.accept(())
                                }
                            )
                        )
                    ))
                case .failure(let error):
                    owner.priv.error.accept(error)
                }
            }
            .disposed(by: priv.disposeBag)
        
        priv.course
            .filter { [weak self] _ in self?.priv.inputCourse != nil }
            .flatMap {
                RealmRepository.shared.updateCourse($0)
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let course):
                    presentModalVC.accept(ModalViewController(
                        viewModel: ModalViewModel(
                            info: ModalInfo(
                                title: C.saveTitle,
                                message: C.updateCourseMessage,
                                submitHandler: {
                                    dismissVC.accept(())
                                    owner.priv.submitHander?(course)
                                }
                            )
                        )
                    ))
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
        
        Observable<ActionType>.merge(
            courseFolder.map { _ in .createFormCourseFolder },
            imageTap.map { _ in .createFormImage },
            saveTap.map { .createFormSave }
        )
        .bind(with: self) { owner, action in
            FirebaseAnalyticsManager.shared.logEventInScreen(
                action: action,
                screen: .createForm
            )
        }
        .disposed(by: priv.disposeBag)
        
        return Output(
            courseFolderPickerItems: courseFolderPickerItems,
            courseFolderTitle: courseFolderTitle,
            image: image,
            title: title,
            content: content,
            presentImagePickerVC: presentImagePickerVC,
            presentModalVC: presentModalVC,
            dismissVC: dismissVC,
            rootTBC: rootTBC
        )
    }
    
}
