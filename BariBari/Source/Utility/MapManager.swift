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
    
    func openNaverMap(coords: [Coord]) {
        guard let appName = Bundle.main.bundleIdentifier ?? C.appNamePlaceholder
        
//        let urlString = "nmap://route/car?lat=\(coord.lat)&lng=\(coord.long)&name=목적지&appname=\(appName)"
        
        guard let encodedStr = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: encodedStr),
              let appStoreURL = URL(string: "itms-apps://itunes.apple.com/app/id311867728?mt=8")
        else { return }
        
        UIApplication.shared.open(url, options: [:]) { success in
            if !success { UIApplication.shared.open(appStoreURL) }
        }
    }
    
}
