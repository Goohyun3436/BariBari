//
//  CourseModel.swift
//  BariBari
//
//  Created by Goo on 4/3/25.
//

import Foundation
import RealmSwift

struct CourseFolder {
    let _id: ObjectId
    let image: String?
    let title: String
    let courses: [Course]
    
    func toNewRealm() -> CourseFolderTable {
        return CourseFolderTable(
            image: image,
            title: title
        )
    }
}

struct Course {
    let _id: ObjectId
    let folder: ObjectId?
    let image: String?
    let title: String
    let content: String?
    let duration: Int
    let zone: String
    let pins: [Pin]
    
    func toNewRealm() -> CourseTable {
        return CourseTable(
            image: image,
            title: title,
            content: content,
            duration: duration,
            zone: zone
        )
    }
}

struct Pin {
    let _id: ObjectId
    let address: String
    let zone: String
    let coord: Coord?
    
    func toNewRealm() -> PinTable? {
        guard let coord else { return nil }
        
        return PinTable(
            address: address,
            zone: zone,
            lat: coord.lat,
            lng: coord.lng
        )
    }
}
