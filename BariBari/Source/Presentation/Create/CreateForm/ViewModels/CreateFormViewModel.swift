//
//  CreateFormViewModel.swift
//  BariBari
//
//  Created by Goo on 4/2/25.
//

import Foundation
import MapKit
import RxSwift
import RxCocoa

final class CreateFormViewModel: BaseViewModel {
    
    //MARK: - Input
    struct Input {
        let viewWillAppear: ControlEvent<Void>
        let title: ControlProperty<String?>
        let content: ControlProperty<String?>
//        let image:
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
        let title: PublishRelay<String?>
        let content: PublishRelay<String?>
        let presentModalVC: PublishRelay<BaseViewController>
        let dismissVC: PublishRelay<Void>
        let rootTBC: PublishRelay<Void>
    }
    
    //MARK: - Private
    private struct Private {
        let coords: [CLLocationCoordinate2D]
        let courseFolderFetchTrigger = PublishRelay<Void>()
        let courseFolders = PublishRelay<[CourseFolder]>()
        let courseFolder = BehaviorRelay<CourseFolder?>(value: nil)
        let pendingCourse = BehaviorRelay<Course?>(value: nil)
        let course = PublishRelay<Course>()
        let disposeBag = DisposeBag()
    }
    
    //MARK: - Property
    private let priv: Private
    
    init(coords: [CLLocationCoordinate2D]) {
        priv = Private(coords: coords)
    }
    
    //MARK: - Transform
    func transform(input: Input) -> Output {
        let courseFolderPickerItems = PublishRelay<(
            items: [CourseFolder],
            createFolderHandler: (() -> Void)?,
            completionHandler: ((CourseFolder) -> Void)?
        )>()
        let courseFolderTitle = PublishRelay<String?>()
        let title = PublishRelay<String?>()
        let content = PublishRelay<String?>()
        let presentModalVC = PublishRelay<BaseViewController>()
        let dismissVC = PublishRelay<Void>()
        let rootTBC = PublishRelay<Void>()
        
        let courseFolders = priv.courseFolders.share(replay: 1)
        let pendingCourse = priv.pendingCourse.share(replay: 1)
        
        input.viewWillAppear
            .bind(to: priv.courseFolderFetchTrigger)
            .disposed(by: priv.disposeBag)
        
        priv.courseFolderFetchTrigger
            .map {
                RealmRepository.shared.fetchCourseFolders()
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
                                saveHandler: { courseFolder in
                                    self?.priv.courseFolderFetchTrigger.accept(())
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
            .map { $0.first }
            .bind(to: priv.courseFolder)
            .disposed(by: priv.disposeBag)
        
        priv.courseFolder
            .filter { $0 == nil }
            .map { _ in C.courseFolderPickerTitle }
            .bind(to: courseFolderTitle)
            .disposed(by: priv.disposeBag)
        
        input.quitTap
            .map {
                ModalViewController(
                    viewModel: ModalViewModel(
                        info: ModalInfo(
                            title: C.warning,
                            message: C.createFormQuitMessage,
                            cancelHandler: { dismissVC.accept(()) },
                            submitHandler: { rootTBC.accept(()) }
                        )
                    )
                )
            }
            .bind(to: presentModalVC)
            .disposed(by: priv.disposeBag)
        
        input.saveTap
            .withLatestFrom(
                Observable.combineLatest(self.priv.courseFolder, input.title, input.content)
            )
            .flatMap { [weak self] in
                CreateCourseError.validation(
                    courseFolder: $0.0,
                    title: $0.1,
                    content: $0.2,
                    coords: self?.priv.coords
                )
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let course):
                    owner.priv.pendingCourse.accept(course)
                case .failure(let error):
                    dump(error)
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
            .filter { course in
                course != nil && course?.destinationPin != nil
            }
            .flatMapLatest {
                APIRepository.shared.request(
                    NMapRequest.reverseGeocode($0!.destinationPin!.coord!),
                    NMapResponseDTO.self,
                    NMapStatus.self,
                    NMapError.self
                )
            }
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, response in
                switch response {
                case .success(let data):
                    guard var pendingCourse = owner.priv.pendingCourse.value,
                          let pendingPin = pendingCourse.destinationPin,
                          let destinationPin = data.transform(with: pendingPin),
                          let zone = destinationPin.zone
                    else { return } //refactor validation 필요
                    
                    pendingCourse.destinationPin = destinationPin
                    pendingCourse.zone = zone
                    owner.priv.course.accept(pendingCourse)
                case .failure(let error):
                    dump(error)
                }
            })
            .disposed(by: priv.disposeBag)
        
        priv.course
            .withLatestFrom(priv.courseFolder) { (course: $0, folderId: $1?._id) }
            .filter { $0.folderId != nil }
            .flatMap {
                RealmRepository.shared.addCourse($0.course, toFolder: $0.folderId!)
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let course):
                    dump(course)
                    rootTBC.accept(())
                case .failure(let error):
                    dump(error)
                }
            }
            .disposed(by: priv.disposeBag)
        
        return Output(
            courseFolderPickerItems: courseFolderPickerItems,
            courseFolderTitle: courseFolderTitle,
            title: title,
            content: content,
            presentModalVC: presentModalVC,
            dismissVC: dismissVC,
            rootTBC: rootTBC
        )
    }
    
}
