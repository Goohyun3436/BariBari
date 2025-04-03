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
        let courseFolderPickerNoneItem: PublishRelay<(
            items: [String],
            completionHandler: (() -> Void)?
        )>
        let courseFolderPickerItems: PublishRelay<(
            items: [CourseFolder],
            completionHandler: ((CourseFolder) -> Void)?
        )>
        let presentModalVC: PublishRelay<BaseViewController>
        let dismissVC: PublishRelay<Void>
        let rootTBC: PublishRelay<Void>
    }
    
    //MARK: - Private
    private struct Private {
        let courseFolders = PublishRelay<[CourseFolder]>()
        let coords: [CLLocationCoordinate2D]
        let disposeBag = DisposeBag()
    }
    
    //MARK: - Property
    private let priv: Private
    
    init(coords: [CLLocationCoordinate2D]) {
        priv = Private(coords: coords)
    }
    
    //MARK: - Transform
    func transform(input: Input) -> Output {
        let courseFolderPickerNoneItem = PublishRelay<(
            items: [String],
            completionHandler: (() -> Void)?
        )>()
        let courseFolderPickerItems = PublishRelay<(
            items: [CourseFolder],
            completionHandler: ((CourseFolder) -> Void)?
        )>()
        let presentModalVC = PublishRelay<BaseViewController>()
        let dismissVC = PublishRelay<Void>()
        let rootTBC = PublishRelay<Void>()
        
        let courseFolders = priv.courseFolders.share(replay: 1)
        
        input.viewWillAppear
            .map {
                RealmRepository.shared.fetchCourseFolders()
            }
            .bind(to: priv.courseFolders)
            .disposed(by: priv.disposeBag)
        
        courseFolders
            .filter { $0.isEmpty }
            .map { _ in
                (
                    items: [C.courseFolderCreateTitle],
                    completionHandler: { print("코스 폴더 생성 모달") }
                )
            }
            .bind(to: courseFolderPickerNoneItem)
            .disposed(by: priv.disposeBag)
        
        courseFolders
            .filter { !$0.isEmpty }
            .map { _ in
                (
                    items: RealmRepository.shared.fetchCourseFolders(),
                    completionHandler: { courseFolder in print(courseFolder) }
                )
            }
            .bind(to: courseFolderPickerItems)
            .disposed(by: priv.disposeBag)
        
        input.quitTap
            .map {
                ModalViewController(
                    viewModel: ModalViewModel(
                        info: ModalInfo(
                            title: "경고",
                            message: "코스 추적 기록을 종료하시겠습니까?\n해당 추적 내역이 저장되지 않으며,\n되돌릴 수 없습니다.",
                            cancelHandler: { dismissVC.accept(()) },
                            submitHandler: { rootTBC.accept(()) }
                        )
                    )
                )
            }
            .bind(to: presentModalVC)
            .disposed(by: priv.disposeBag)
        
        input.saveTap
//            .withLatestFrom(
//                Observable.combineLatest(input.title, input.content)
//            )
//            .map
            
            .map { [weak self] _ in
                print(input.title)
                print(input.content)
                print(self?.priv.coords)
            }
            .bind(to: rootTBC)
            .disposed(by: priv.disposeBag)
        
        return Output(
            courseFolderPickerNoneItem: courseFolderPickerNoneItem,
            courseFolderPickerItems: courseFolderPickerItems,
            presentModalVC: presentModalVC,
            dismissVC: dismissVC,
            rootTBC: rootTBC
        )
    }
    
//    private func validation(title: String?, content: String?) -> Course {
//        guard let title else { return }
//        
//        
//    }
//    
}
