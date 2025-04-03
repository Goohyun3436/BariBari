//
//  RealmTable.swift
//  BariBari
//
//  Created by Goo on 3/29/25.
//

import Foundation
import RealmSwift

class CourseFolderTable: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var image: String?
    @Persisted var title: String
    @Persisted var courses: List<CourseTable>
    
    convenience init(image: String?, title: String) {
        self.init()
        self.image = image
        self.title = title
    }
}

class CourseTable: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var image: String?
    @Persisted var title: String
    @Persisted var content: String?
    @Persisted var duration: Int
    @Persisted var zone: String
    @Persisted var pins = List<PinTable>()
    @Persisted(originProperty: "courses") var folder: LinkingObjects<CourseFolderTable>
    
    convenience init(image: String?, title: String, content: String?, duration: Int, zone: String) {
        self.init()
        self.image = image
        self.title = title
        self.content = content
        self.duration = duration
        self.zone = zone
    }
}

class PinTable: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var address: String
    @Persisted var zone: String
    @Persisted var lat: Double?
    @Persisted var lng: Double?
    @Persisted(originProperty: "pins") var courses: LinkingObjects<CourseTable>
    
    convenience init(address: String, zone: String, lat: Double?, lng: Double?) {
        self.init()
        self.address = address
        self.zone = zone
        self.lat = lat
        self.lng = lng
    }
}
