//
//  AppError.swift
//  BariBari
//
//  Created by Goo on 4/6/25.
//

import Foundation

protocol AppError {
    var title: String { get }
    var message: String { get }
}
