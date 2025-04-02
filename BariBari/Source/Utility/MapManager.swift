//
//  MapManager.swift
//  BariBari
//
//  Created by Goo on 3/31/25.
//

import UIKit

protocol MapManagerProtocol {
    func openNaverMap(coords: [Coord])
}

final class MapManager: MapManagerProtocol {
    
    static let shared = MapManager()
    
    func openNaverMap(coords: [Coord]) {
        guard !coords.isEmpty else { return }
        
        let appName = Bundle.main.bundleIdentifier ?? C.appNamePlaceholder
        
        guard var urlComponents = URLComponents(string: MapUrl.naver) else { return }
        var queryItems = [URLQueryItem]()
        
        for (i, el) in coords.enumerated() {
            let k = i == coords.count - 1 ? "d" : "v"
            let n = i == coords.count - 1 ? "" : "\(i + 1)"
            
            queryItems.append(URLQueryItem(name: "\(k)\(n)lat", value: "\(el.lat)"))
            queryItems.append(URLQueryItem(name: "\(k)\(n)lng", value: "\(el.lng)"))
            queryItems.append(URLQueryItem(name: "\(k)\(n)name", value: el.name))
            queryItems.append(URLQueryItem(name: "\(k)\(n)ecoords", value: "\(el.lat),\(el.lng)"))
        }
        
        queryItems.append(URLQueryItem(name: "appName", value: appName))
        
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url,
              let appStoreURL = URL(string: AppStoreUrl.naverMap)
        else { return }
        
        UIApplication.shared.open(url, options: [:]) { success in
            if !success { UIApplication.shared.open(appStoreURL) }
        }
    }
    
}
