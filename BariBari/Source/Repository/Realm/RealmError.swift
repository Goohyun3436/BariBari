//
//  RealmError.swift
//  BariBari
//
//  Created by Goo on 4/5/25.
//

import Foundation

enum RealmRepositoryError: Error {
    case courseFolderNotFound
    case courseNotFound
    case invalidData
    case duplicateName
    case writeError
    case missingCoordinates
    
    var title: String {
        return "보관함 오류"
    }
    
    var message: String {
        switch self {
        case .courseFolderNotFound:
            return "코스 폴더를 찾을 수 없습니다."
        case .courseNotFound:
            return "코스를 찾을 수 없습니다."
        case .invalidData:
            return ""
        case .duplicateName:
            return "이미 존재하는 이름입니다."
        case .writeError:
            return "데이터 저장에 실패했습니다."
        case .missingCoordinates:
            return "해당 코스의 위경도 정보가 올바르지 않아 저장에 실패했습니다."
        }
    }
}
