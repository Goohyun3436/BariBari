//
//  NMapError.swift
//  BariBari
//
//  Created by Goo on 3/29/25.
//

import Foundation

enum NMapError: String, AppError, APIError {
    case invalidRequest
    case unknownInMap
    case unknown
    
    init(statusCode: Int) {
        switch statusCode {
        case 400:
            self = .invalidRequest
        case 500:
            self = .unknownInMap
        case 0:
            self = .unknown
        default:
            self = .unknown
        }
    }
    
    var title: String {
        return "네트워크 에러"
    }
    
    var message: String {
        return "\(self.description) (\(self.rawValue))"
    }
    
    private var description: String {
        switch self {
        case .invalidRequest:
            return "코스의 주소 정보를 가져오는데에 실패했습니다. 관리자에게 문의하세요."
        case .unknownInMap:
            return "네이버 지도에 문제가 발생했습니다. 관리자에게 문의하세요."
        case .unknown:
            return "바리바리가 주소 정보를 가져오는 중에 문제가 발생했습니다. 관리자에게 문의하세요."
        }
    }
    
}
