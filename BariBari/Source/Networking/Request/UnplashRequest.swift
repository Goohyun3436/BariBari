//
//  UnplashRequest.swift
//  BariBari
//
//  Created by Goo on 4/7/25.
//

import Foundation

enum UnplashRequest: APIRequest {
    case search(_ query: String,
                _ page: Int = 1,
                perPage: Int = 1,
                _ orderBy: OrderBy = .relevant
    )
    
    var endpoint: String {
        return APIUrl.unsplash + self.path
    }
    
    private var path: String {
        switch self {
        case .search:
            return "/search/photos"
        }
    }
    
    var parameters: Parameters {
        switch self {
        case .search(let query, let page, let perPage, let orderBy):
            return [
                "query": query,
                "page": "\(page)",
                "per_page": "\(perPage)",
                "order_by": orderBy.rawValue
            ]
        }
    }
    
    var headers: HTTPHeaders {
        return ["Authorization": APIKey.unsplash]
    }
}

enum OrderBy: String {
    case relevant
    case latest
}
