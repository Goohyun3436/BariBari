//
//  ValidationModel.swift
//  BariBari
//
//  Created by Goo on 4/3/25.
//

import Foundation
import RxSwift
import RealmSwift

//MARK: - Course Folder
enum CreateCourseFolderError: AppError {
    case emptyTitle
    
    var title: String {
        return "저장 실패"
    }
    
    var message: String {
        switch self {
        case .emptyTitle:
            return "코스 폴더 이름을 입력해주세요."
        }
    }
    
    static func validation(_id: ObjectId?, title: String?, image: Data?) -> Single<Result<CourseFolder, CreateCourseError>> {
        return Single<Result<CourseFolder, CreateCourseError>>.create { observer in
            let disposables = Disposables.create()
            
            guard var title else {
                observer(.success(.failure(.emptyTitle)))
                return disposables
            }
            
            title = title.trimmingCharacters(in: .whitespaces)
            
            guard !title.isEmpty else {
                observer(.success(.failure(.emptyTitle)))
                return disposables
            }
            
            observer(.success(.success(CourseFolder(
                _id: _id,
                image: image,
                title: title,
                courses: []
            ))))
            
            return disposables
        }
    }
}

//MARK: - Course
enum CreateCourseError: AppError, Error {
    case emptyCourseFolder
    case emptyTitle
    case emptyPin
    case minimumPin
    
    var title: String {
        return "저장 실패"
    }
    
    var message: String {
        switch self {
        case .emptyCourseFolder:
            return "코스 폴더를 선택해주세요."
        case .emptyTitle:
            return "코스 이름을 입력해주세요."
        case .emptyPin:
            return "현재 코스에 핀이 없습니다."
        case .minimumPin:
            return "최소 2개 이상의 핀이 필요합니다."
        }
    }
    
    static func validation(
        _id: ObjectId?,
        courseFolder: CourseFolder?,
        image: Data?,
        title: String?,
        content: String?,
        pins: [Pin]?
    ) -> Single<Result<Course, CreateCourseError>> {
        return Single<Result<Course, CreateCourseError>>.create { observer in
            let disposables = Disposables.create()
            
            guard let courseFolder else {
                observer(.success(.failure(.emptyCourseFolder)))
                return disposables
            }
            
            guard var title else {
                observer(.success(.failure(.emptyTitle)))
                return disposables
            }
            
            title = title.trimmingCharacters(in: .whitespaces)
            var content = content?.trimmingCharacters(in: .whitespaces)
            content = ( content == C.textFiledPlaceholder || content?.isEmpty ?? true) ? nil : content
            
            guard !title.isEmpty else {
                observer(.success(.failure(.emptyTitle)))
                return disposables
            }
            
            guard let pins else {
                observer(.success(.failure(.emptyPin)))
                return disposables
            }
            
            guard pins.count >= 2 else {
                observer(.success(.failure(.minimumPin)))
                return disposables
            }
            
            let directionPins = MapManager.shared.selectPins(pins)
            
            observer(.success(.success(Course(
                _id: _id,
                folder: courseFolder,
                image: image,
                title: title,
                content: content,
                duration: 0, //refactor API
                zone: "",
                destinationPin: directionPins.last,
                pins: pins,
                directionPins: directionPins
            ))))
            
            return disposables
        }
    }
}

enum FetchCourseError: AppError, Error {
    case moveCourseFolder
    
    var title: String {
        return C.info
    }
    
    var message: String {
        switch self {
        case .moveCourseFolder:
            return "해당 코스의 폴더가 이동되었습니다."
        }
    }
}
