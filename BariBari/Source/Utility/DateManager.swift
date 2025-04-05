//
//  DateManager.swift
//  BariBari
//
//  Created by Goo on 3/29/25.
//

import Foundation

final class DateManager {
    
    static let shared = DateManager()
    
    private init() {}
    
    func convertFormat(
        with date: Date,
        to format: String = C.dateFormat
    ) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
    
}
