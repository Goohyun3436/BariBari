//
//  UnsplashError.swift
//  BariBari
//
//  Created by Goo on 4/7/25.
//

import Foundation

struct UnsplashErrorResponse: APIErrorResponse {
    var code: Int
    var errors: [String]
}

enum UnsplashError: String, AppError, APIError {
    case badRequest
    case unauthorized
    case forbidden
    case notFound
    case server
    case unowned
    
    init(statusCode: Int) {
        switch statusCode {
        case 400:
            self = .badRequest
        case 401:
            self = .unauthorized
        case 403:
            self = .forbidden
        case 404:
            self = .notFound
        case 500, 503:
            self = .server
        default:
            self = .unowned
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
        case .badRequest, .notFound, .unauthorized, .forbidden, .unowned:
            return "바리바리가 사진 정보를 가져오는 중에 문제가 생겼습니다. 관리자에게 문의하세요."
        case .server:
            return "Unsplash 서버에 문제가 생겼습니다."
        }
    }
}
