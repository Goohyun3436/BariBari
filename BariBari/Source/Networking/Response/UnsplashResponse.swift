//
//  UnsplashResponse.swift
//  BariBari
//
//  Created by Goo on 4/7/25.
//

import Foundation

struct UnsplashResponse: Decodable {
    let results: [PhotoInfo]
}

struct PhotoInfo: Decodable {
    let urls: UrlsInfo
    let width: Int
    let height: Int
}

struct UrlsInfo: Decodable {
    let small: String
}
