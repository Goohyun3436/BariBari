//
//  CourseModel.swift
//  BariBari
//
//  Created by Goo on 4/3/25.
//

import Foundation

struct CourseFolder: Identifiable {
    let id = UUID()
    let image: String?
    let title: String
    let courses: [Course]
}

struct Course: Identifiable {
    let id = UUID()
    let image: String?
    let title: String
    let content: String?
    let duration: Int
    let zone: String
    let pins: [Pin]
//    let folder: String
}

struct Pin {
    let id = UUID()
    let address: String
    let zone: String
    let coord: Coord?
}
