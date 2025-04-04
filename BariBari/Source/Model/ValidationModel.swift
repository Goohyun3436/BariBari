//
//  ValidationModel.swift
//  BariBari
//
//  Created by Goo on 4/3/25.
//

import Foundation
import MapKit
import RxSwift

enum CreateCourseError: Error {
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
        courseFolder: CourseFolder?,
        title: String?,
        content: String?,
        coords: [CLLocationCoordinate2D]?
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
            
            guard !title.isEmpty else {
                observer(.success(.failure(.emptyTitle)))
                return disposables
            }
            
            guard let coords else {
                observer(.success(.failure(.emptyPin)))
                return disposables
            }
                    
            guard coords.count >= 2,
                  let destination = coords.last else {
                observer(.success(.failure(.minimumPin)))
                return disposables
            }
            
            let content = content == C.textFiledPlaceholder ? nil : content
            
            let destinationPin = Pin(coord: Coord(lat: destination.latitude, lng: destination.longitude))
            
            var pins = coords.map { Pin(coord: Coord(lat: $0.latitude, lng: $0.longitude)) }
            pins[0].address = C.startPinTitle
            pins[pins.count - 1].address = C.destinationPinTitle
            
            observer(.success(.success(Course(
                folder: courseFolder._id,
                image: nil, //refactor: image
                title: title,
                content: content,
                duration: 0, //refactor API
                zone: "",
                destinationPin: destinationPin,
                pins: pins
            ))))
            
            return disposables
        }
    }
}
