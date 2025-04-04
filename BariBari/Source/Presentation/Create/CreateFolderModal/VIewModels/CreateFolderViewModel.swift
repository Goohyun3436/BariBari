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
    struct Input {}
    
    //MARK: - Output
    struct Output {}
    
    //MARK: - Private
    private struct Private {
        let cancelHandler: () -> Void
        let saveHandler: (CourseFolder) -> Void
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
        return Output()
    }
    
}
