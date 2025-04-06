//
//  NumberFormatManager.swift
//  BariBari
//
//  Created by Goo on 4/3/25.
//

import Foundation

protocol NumberFormatManagerProtocol {
    func formatted(_ num: Double) -> String
}

final class NumberFormatManager: NumberFormatManagerProtocol {
    
    static let shared = NumberFormatManager()
    
    private init() {}
    
    enum NumberType {
        case int
        case double1f
        case double2f
        case zero
        
        init(_ num: Double) {
            if num == 0 {
                self = .zero
                return
            }
            
            if num == Double(Int(num)) {
                self = .int
                return
            }
            
            if let last = String(format: "%.2f", num).last, last == "0" {
                self = .double1f
            } else {
                self = .double2f
            }
        }
    }
    
    func formatted(_ num: Double) -> String {
        switch NumberType(num) {
        case .int:
            return num.formatted()
        case .double1f:
            return String(format: "%.1f", num)
        case .double2f:
            return String(format: "%.2f", num)
        case .zero:
            return "0"
        }
    }
    
}
