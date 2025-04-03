//
//  RealmProtocol.swift
//  BariBari
//
//  Created by Goo on 4/3/25.
//

import Foundation
import RealmSwift

protocol CourseFolderRepository {
    func fetchCourseFolders() -> [CourseFolder]
    func fetchCourseFolder(_ folderId: ObjectId) -> CourseFolder?
    func addCourseFolder(_ folder: CourseFolder)
    func updateCourseFolder(_ folder: CourseFolder)
    func deleteCourseFolder(_ folderId: ObjectId)
}

protocol CourseRepository {
    func fetchCourses() -> [Course]
    func fetchCourse(_ courseId: ObjectId) -> Course?
    func addCourse(_ course: Course, toFolder folderId: ObjectId)
    func updateCourse(_ course: Course)
    func deleteCourse(_ courseId: ObjectId)
}
