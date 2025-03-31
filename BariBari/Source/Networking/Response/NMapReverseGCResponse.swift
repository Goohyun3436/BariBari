//
//  NMapResponse.swift
//  BariBari
//
//  Created by Goo on 3/29/25.
//

import Foundation

struct NMapStatus: Decodable {
    let code: Int
    let name: String
    let message: String
}

struct NMapResponseDTO: Decodable {
    let status: NMapStatus
    let results: [NMapResultDTO]
    
    func transform() -> 
}

struct NMapResultDTO: Decodable {
    let region: NMapRegionDTO
}

struct NMapRegionDTO: Decodable {
    let area1: NMapArea1
    let area2, area3, area4: NMapArea
}

struct NMapArea: Decodable {
    let name: String
}

struct NMapArea1: Decodable {
    let name: String
    let alias: String
}
