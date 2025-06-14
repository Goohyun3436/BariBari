//
//  RealmProtocol.swift
//  BariBari
//
//  Created by Goo on 4/3/25.
//

import Foundation
import RxSwift
import RealmSwift

protocol ResetRepository {
    func reset() -> Single<Result<Void, RealmRepositoryError>>
}

protocol CourseFolderRepository {
    func fetchCourseFolders() -> [CourseFolder]
    func fetchCourseFolder(_ folderId: ObjectId) -> Single<Result<CourseFolder, RealmRepositoryError>>
    func addTemporaryCourseFolder() -> Single<Result<CourseFolder, RealmRepositoryError>>
    func addCourseFolder(_ folder: CourseFolder) -> Single<Result<CourseFolder, RealmRepositoryError>>
    func updateCourseFolder(_ folder: CourseFolder) -> Single<Result<CourseFolder, RealmRepositoryError>>
    func deleteCourseFolder(_ folderId: ObjectId) -> Single<Result<Void, RealmRepositoryError>>
}

protocol CourseRepository {
    func fetchCourses() -> [Course]
    func fetchCourses(fromFolder folderId: ObjectId) -> [Course]
    func fetchCourse(_ courseId: ObjectId) -> Single<Result<Course, RealmRepositoryError>>
    func fetchRandomCourse() -> CourseThumbnail?
    func addCourse(_ course: Course, toFolder folderId: ObjectId) -> Single<Result<Void, RealmRepositoryError>>
    func updateCourse(_ course: Course) -> Single<Result<Course, RealmRepositoryError>>
    func deleteCourse(_ courseId: ObjectId) -> Single<Result<Void, RealmRepositoryError>>
}
