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
    @Persisted var image: Data?
    @Persisted var title: String
    @Persisted var courses: List<CourseTable>
    @Persisted var date: Date
    
    convenience init(image: Data?, title: String) {
        self.init()
        self.image = image
        self.title = title
        self.date = Date()
    }
    
    func transform() -> CourseFolder {
        return CourseFolder(
            _id: _id,
            image: image,
            title: title,
            courses: courses.map { $0.transform() }
        )
    }
    
    func transformWithoutCourses() -> CourseFolder {
        return CourseFolder(
            _id: _id,
            image: image,
            title: title,
            courses: []
        )
    }
}

class CourseTable: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var thumbnail: Data?
    @Persisted var image: Data?
    @Persisted var title: String
    @Persisted var content: String?
    @Persisted var duration: Int
    @Persisted var zone: String
    @Persisted var date: Date
    @Persisted var destinationPin: PinTable?
    @Persisted var pins: List<PinTable>
    @Persisted var directionPins: List<PinTable>
    @Persisted(originProperty: "courses") var folder: LinkingObjects<CourseFolderTable>
    
    convenience init(thumbnail: Data?, image: Data?, title: String, content: String?, duration: Int, zone: String, destinationPin: PinTable?) {
        self.init()
        self.thumbnail = thumbnail
        self.image = image
        self.title = title
        self.content = content
        self.duration = duration
        self.zone = zone
        self.date = Date()
        self.destinationPin = destinationPin
    }
    
    func transform() -> Course {
        return Course(
            _id: _id,
            folder: folder.first?.transformWithoutCourses(), //refactor folder가 없을 수 없음
            image: image,
            title: title,
            content: content,
            duration: duration,
            zone: zone,
            date: DateManager.shared.convertFormat(with: date),
            destinationPin: destinationPin?.transform(),
            pins: pins.map { $0.transform() },
            directionPins: directionPins.map { $0.transform() }
        )
    }
    
    func transformToThumbnail() -> CourseThumbnail {
        return CourseThumbnail(
            _id: _id,
            folder: folder.first?.transformWithoutCourses(),
            image: thumbnail,
            title: title,
            address: destinationPin?.address ?? C.addressPlaceholder,
            date: DateManager.shared.convertFormat(with: date)
        )
    }
}

class PinTable: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var address: String?
    @Persisted var zone: String?
    @Persisted var lat: Double
    @Persisted var lng: Double
    @Persisted(originProperty: "pins") var courses: LinkingObjects<CourseTable>
    
    convenience init(address: String?, zone: String?, lat: Double, lng: Double) {
        self.init()
        self.address = address
        self.zone = zone
        self.lat = lat
        self.lng = lng
    }
    
    func transform() -> Pin {
        return Pin(
            _id: _id,
            address: address,
            zone: zone,
            coord: Coord(lat: lat, lng: lng)
        )
    }
}
