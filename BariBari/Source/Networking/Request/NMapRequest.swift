//
//  NMapRequest.swift
//  BariBari
//
//  Created by Goo on 3/29/25.
//

import Foundation

enum NMapRequest: APIRequest {
    case reverseGeocode(
        _ coord: Coord,
        sourceCrs: CoordSystem = .EPSG4326,
        targetCrs: CoordSystem = .EPSG4326,
        orders: [AddressType] = [.admCode],
        output: OutputType = .json
    )
    
    var endpoint: String {
        return APIUrl.naver + self.path
    }
    
    private var path: String {
        switch self {
        case .reverseGeocode:
            return "/map-reversegeocode/v2/gc"
        }
    }
    
    var parameters: Parameters {
        switch self {
        case .reverseGeocode(let coord, let sourceCrs, let targetCrs, let orders, let output):
            return [
                "coords": "\(coord.lng),\(coord.lat)",
                "sourcecrs": sourceCrs.rawValue,
                "targetcrs": targetCrs.rawValue,
                "orders": orders.map { $0.rawValue }.joined(separator: ","),
                "output": output.rawValue
            ]
        }
    }
    
    var headers: HTTPHeaders {
        return [
            "x-ncp-apigw-api-key-id": APIKey.naverClientId,
            "x-ncp-apigw-api-key": APIKey.naverClientSecret
        ]
    }
}


enum CoordSystem: String {
    case EPSG4326 = "EPSG:4326"
    case EPSG3857 = "EPSG:3857"
    case NHN2048 = "NHN:2048"
}

enum AddressType: String {
    case legalCode = "legalcode"
    case admCode = "admcode"
    case addr = "addr"
    case roadAddr = "roadaddr"
}

enum OutputType: String {
    case json
    case xml
}
