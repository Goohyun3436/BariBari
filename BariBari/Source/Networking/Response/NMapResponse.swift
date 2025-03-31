//
//  NMapResponse.swift
//  BariBari
//
//  Created by Goo on 3/31/25.
//

import Foundation

struct NMapStatus: Decodable, APIErrorResponse {
    let code: Int
    let name: String
    let message: String
}
