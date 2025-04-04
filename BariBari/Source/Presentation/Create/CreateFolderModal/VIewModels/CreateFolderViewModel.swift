//
//  CreateFolderViewModel.swift
//  BariBari
//
//  Created by Goo on 4/4/25.
//

import Foundation
import MapKit
import RxSwift
import RxCocoa

final class CreateFolderViewModel: BaseViewModel {
    
    //MARK: - Input
    struct Input {
        let title: ControlProperty<String?>
//        let image:
        let cancelTap: ControlEvent<Void>
        let saveTap: ControlEvent<Void>
    }
    
    //MARK: - Output
    struct Output {}
    
    //MARK: - Private
    private struct Private {
        let cancelHandler: () -> Void
        let saveHandler: (CourseFolder) -> Void
        let courseFolder = PublishRelay<CourseFolder>()
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
        
        input.cancelTap
            .bind(with: self) { owner, _ in
                owner.priv.cancelHandler()
            }
            .disposed(by: priv.disposeBag)
        
        input.saveTap
            .withLatestFrom(input.title)
//            .withLatestFrom(
//                Observable.combineLatest(input.title, input.image)
//            )
            .flatMap {
                CreateCourseFolderError.validation(title: $0)
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
        
        return Output()
    }
    
}
