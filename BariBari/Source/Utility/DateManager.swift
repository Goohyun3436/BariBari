//
//  DateManager.swift
//  BariBari
//
//  Created by Goo on 3/29/25.
//

import Foundation

protocol DateManagerProtocol {
    func convertFormat(with date: Date, to format: String) -> String
}

final class DateManager: DateManagerProtocol {
    
    static let shared = DateManager()
    
    private init() {}
    
    func getDate() -> String {
        return convertFormat(with: Date())
    }
    
    func convertFormat(
        with date: Date,
        to format: String = C.dateFormatWithTime
    ) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
    
}
