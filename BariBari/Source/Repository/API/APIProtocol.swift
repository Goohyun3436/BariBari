//
//  APIProtocol.swift
//  BariBari
//
//  Created by Goo on 3/31/25.
//

import Foundation
import RxSwift

typealias Parameters = [String: String]
typealias HTTPHeaders = [String: String]

protocol APIRequest {
    var endpoint: String { get }
    var parameters: Parameters { get }
    var headers: HTTPHeaders { get }
}

protocol APIErrorResponse: Decodable {
    var code: Int { get }
}

protocol APIError: Error {
    init(statusCode: Int)
    var title: String { get }
    var message: String { get }
}

protocol APIRepositoryProtocol {
    func request<ResponseType: Decodable, ErrorResponseType: APIErrorResponse, ErrorType: APIError>(
        _ request: APIRequest,
        _ responseT: ResponseType.Type,
        _ errorResponseT: ErrorResponseType.Type,
        _ errorT: ErrorType.Type
    ) -> Single<Result<ResponseType, ErrorType>>
}
