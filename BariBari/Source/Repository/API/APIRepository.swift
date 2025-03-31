//
//  APIRepository.swift
//  BariBari
//
//  Created by Goo on 3/29/25.
//

import Foundation
import RxSwift

final class APIRepository: APIRepositoryProtocol {
    
    static let shared = APIRepository()
    
    private init() {}
    
    func request<ResponseType: Decodable, ErrorResponseType: APIErrorResponse, ErrorType: APIError>(
        _ request: APIRequest,
        _ responseT: ResponseType.Type,
        _ errorResponseT: ErrorResponseType.Type,
        _ errorT: ErrorType.Type
    ) -> Single<Result<ResponseType, ErrorType>> {
        
        return Single<Result<ResponseType, ErrorType>>.create { observer in
            let disposables = Disposables.create()
            
            guard let urlRequest = self.setupRequest(request) else {
                observer(.success(.failure(ErrorType(statusCode: 0))))
                return disposables
            }
            
            URLSession.shared.dataTask(with: urlRequest) { data, response, err in
                
                if let _ = err {
                    observer(.success(.failure(ErrorType(statusCode: 0))))
                    return
                }
                
                guard let data else {
                    observer(.success(.failure(ErrorType(statusCode: 0))))
                    return
                }
                
                guard let response = response as? HTTPURLResponse else {
                    observer(.success(.failure(ErrorType(statusCode: 0))))
                    return
                }
                
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                guard (200...299).contains(response.statusCode) else {
                    do {
                        let error = try decoder.decode(errorResponseT.self, from: data)
                        observer(.success(.failure(ErrorType(statusCode: error.code))))
                    } catch {
                        observer(.success(.failure(ErrorType(statusCode: 0))))
                    }
                    return
                }
                
                do {
                    let response = try decoder.decode(responseT.self, from: data)
                    observer(.success(.success(response)))
                } catch {
                    dump(error)
                    observer(.success(.failure(ErrorType(statusCode: 0))))
                }
            }.resume()
            
            return disposables
        }
    }
    
    private func setupRequest(_ request: APIRequest) -> URLRequest? {
        guard var urlComponents = URLComponents(string: request.endpoint) else { return nil }
        
        urlComponents.queryItems = request.parameters.map {
            URLQueryItem(name: $0.key, value: $0.value)
        }
        
        guard let url = urlComponents.url else { return nil }
        
        var urlRequest = URLRequest(url: url, timeoutInterval: 5)
        
        request.headers.forEach {
            urlRequest.addValue($0.value, forHTTPHeaderField: $0.key)
        }
        
        return urlRequest
    }
    
}
