//
//  NMapReverseGCResponse.swift
//  BariBari
//
//  Created by Goo on 3/29/25.
//

import Foundation

struct NMapResponseDTO: Decodable {
    let status: NMapStatus
    let results: [NMapResultDTO]
    
    func transform(with requestPin: Pin) -> Pin? {
        guard status.code == 0 else {
            return nil
        }
        
        guard let result = results.map({ $0.transform() }).first else {
            return nil
        }
        
        var pin = requestPin
        pin.address = result.name
        pin.zone = result.alias
        
        return pin
    }
}

struct NMapResultDTO: Decodable {
    let name: String
    let region: NMapRegionDTO
    
    func transform() -> NMapAreaWithAlias {
        return region.transform()
    }
}

struct NMapRegionDTO: Decodable {
    let area1: NMapAreaWithAlias
    let area2, area3, area4: NMapArea
    
    func transform() -> NMapAreaWithAlias {
        return NMapAreaWithAlias(
            name: "\(area1.name) \(area2.name) \(area3.name)",
            alias: area1.alias
        )
    }
}

struct NMapAreaWithAlias: Decodable {
    let name: String
    let alias: String
}

struct NMapArea: Decodable {
    let name: String
}
