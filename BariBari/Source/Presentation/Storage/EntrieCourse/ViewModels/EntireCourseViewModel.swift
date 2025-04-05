//
//  EntireCourseViewModel.swift
//  BariBari
//
//  Created by Goo on 4/2/25.
//

import Foundation
import RxSwift
import RxCocoa

final class EntireCourseViewModel: BaseViewModel {
    
    //MARK: - Input
    struct Input {
        let viewWillAppear: ControlEvent<Void>
        let courseFolderTap: ControlEvent<CourseFolder>
    }
    
    //MARK: - Output
    struct Output {
        let courseFolders: BehaviorRelay<[CourseFolder]>
        let noneContentVisible: BehaviorRelay<Bool>
        let pushVC: PublishRelay<CourseFolder>
    }
    
    //MARK: - Private
    private struct Private {
        let disposeBag = DisposeBag()
    }
    
    //MARK: - Property
    private let priv = Private()
    
    //MARK: - Transform
    func transform(input: Input) -> Output {
        let courseFolders = BehaviorRelay<[CourseFolder]>(value: [])
        let noneContentVisible = BehaviorRelay<Bool>(value: false)
        let pushVC = PublishRelay<CourseFolder>()
        
        input.viewWillAppear
            .map {
                RealmRepository.shared.fetchCourseFolders()
            }
            .bind(to: courseFolders)
            .disposed(by: priv.disposeBag)
        
        courseFolders
            .map { !$0.isEmpty }
            .bind(to: noneContentVisible)
            .disposed(by: priv.disposeBag)
        
//        input.courseFolderTap
            
        return Output(
            courseFolders: courseFolders,
            noneContentVisible: noneContentVisible,
            pushVC: pushVC
        )
    }
    
}
