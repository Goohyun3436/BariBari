//
//  CourseModel.swift
//  BariBari
//
//  Created by Goo on 4/3/25.
//

import Foundation
import RealmSwift

struct CourseFolder {
    var _id: ObjectId? = nil
    let image: String?
    let title: String
    let courses: [Course]
    var courseCount: String {
        return "\(courses.count)개의 코스"
    }
    
    func toNewRealm() -> CourseFolderTable {
        return CourseFolderTable(
            image: image,
            title: title
        )
    }
}

struct Course {
    var _id: ObjectId? = nil
    var folder: ObjectId? = nil
    let image: String?
    let title: String
    let content: String?
    let duration: Int
    var zone: String
    var date: String = ""
    var destinationPin: Pin?
    let pins: [Pin]
    var address: String {
        guard let destinationPin,
              let address = destinationPin.address else {
            return C.addressPlaceholder
        }
        
        return address
    }
    
    func toNewRealm() -> CourseTable {
        return CourseTable(
            image: image,
            title: title,
            content: content,
            duration: duration,
            zone: zone,
            destinationPin: destinationPin?.toNewRealm()
        )
    }
}

struct Pin {
    var _id: ObjectId? = nil
    var address: String? = nil
    var zone: String? = nil
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
