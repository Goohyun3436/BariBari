//
//  MapManager.swift
//  BariBari
//
//  Created by Goo on 3/31/25.
//

import UIKit

protocol MapManagerProtocol {
    func openNaverMap(pins: [Pin])
}

final class MapManager: MapManagerProtocol {
    
    static let shared = MapManager()
    
    private init() {}
    
    func openNaverMap(pins: [Pin]) {
        guard !pins.isEmpty else { return }
        
        guard var urlComponents = URLComponents(string: MapUrl.naver) else { return }
        var queryItems = [URLQueryItem]()
        
        for (i, pin) in pins.enumerated() {
            let k = i == pins.count - 1 ? "d" : "v"
            let n = i == pins.count - 1 ? "" : "\(i + 1)"
            
            guard let coord = pin.coord else { return } //alert
            
            queryItems.append(URLQueryItem(name: "\(k)\(n)lat", value: "\(coord.lat)"))
            queryItems.append(URLQueryItem(name: "\(k)\(n)lng", value: "\(coord.lng)"))
            queryItems.append(URLQueryItem(name: "\(k)\(n)name", value: pin.address ?? ""))
            queryItems.append(URLQueryItem(name: "\(k)\(n)ecoords", value: "\(coord.lat),\(coord.lng)"))
        }
        
        let appName = Bundle.main.bundleIdentifier ?? C.appNamePlaceholder
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
