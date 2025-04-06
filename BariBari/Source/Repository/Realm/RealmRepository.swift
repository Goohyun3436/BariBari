//
//  RealmRepository.swift
//  BariBari
//
//  Created by Goo on 3/29/25.
//

import Foundation
import RxSwift
import RealmSwift

final class RealmRepository {
    
    static let shared = RealmRepository()
    
    private let realm = try! Realm()
    
    private init() {}
    
    func printFileURL() {
        print(realm.configuration.fileURL ?? "NotFound fileURL")
    }
    
}

//MARK: - CourseFolder
extension RealmRepository: CourseFolderRepository {
    
    func fetchCourseFolders() -> [CourseFolder] {
        let realmCourseFolders = realm.objects(CourseFolderTable.self)
        let sorted = realmCourseFolders.sorted(byKeyPath: "date", ascending: false)
        return sorted.map { $0.transform() }
    }
    
    func fetchCourseFolder(_ folderId: ObjectId) -> Single<Result<CourseFolder, RealmRepositoryError>> {
        return Single<Result<CourseFolder, RealmRepositoryError>>.create { observer in
            let disposables = Disposables.create()
            
            guard let realmCourseFolder = self.realm.object(
                ofType: CourseFolderTable.self,
                forPrimaryKey: folderId
            ) else {
                observer(.success(.failure(.courseFolderNotFound)))
                return disposables
            }
            
            let courseFolder = realmCourseFolder.transform()
            observer(.success(.success(courseFolder)))
            
            return disposables
        }
    }
    
    func addCourseFolder(_ folder: CourseFolder) -> Single<Result<CourseFolder, RealmRepositoryError>> {
        return Single<Result<CourseFolder, RealmRepositoryError>>.create { observer in
            print("addCourseFolder")
            let disposables = Disposables.create()
            
            let existingFolders = self.realm.objects(CourseFolderTable.self).filter("title == %@", folder.title)
            if !existingFolders.isEmpty {
                observer(.success(.failure(.duplicateName)))
                return disposables
            }
            
            let realmCourseFolder = folder.toNewRealm()
            
            do {
                try self.realm.write {
                    self.realm.add(realmCourseFolder)
                }
                observer(.success(.success((folder))))
            } catch {
                observer(.success(.failure(.writeError)))
            }
            
            return disposables
        }
    }
    
    func updateCourseFolder(_ folder: CourseFolder) -> Single<Result<CourseFolder, RealmRepositoryError>> {
        return Single<Result<CourseFolder, RealmRepositoryError>>.create { observer in
            print("updateCourseFolder")
            let disposables = Disposables.create()
            
            guard let folderId = folder._id,
                  let realmCourseFolder = self.realm.object(
                    ofType: CourseFolderTable.self,
                    forPrimaryKey: folderId
            ) else {
                observer(.success(.failure(.courseFolderNotFound)))
                return disposables
            }
            
            // 이름 중복 체크 (자기 자신은 제외)
            let existingFolders = self.realm.objects(CourseFolderTable.self)
                .filter("title == %@ AND _id != %@", folder.title, folderId)
            if !existingFolders.isEmpty {
                observer(.success(.failure(.duplicateName)))
                return disposables
            }
            
            do {
                try self.realm.write {
                    realmCourseFolder.image = folder.image
                    realmCourseFolder.title = folder.title
                    realmCourseFolder.date = Date()
                }
                let courseFolder = realmCourseFolder.transform()
                observer(.success(.success((courseFolder))))
            } catch {
                print(#function, error)
                observer(.success(.failure(.writeError)))
            }
            
            return disposables
        }
    }
    
    func deleteCourseFolder(_ folderId: ObjectId) -> Single<Result<Void, RealmRepositoryError>> {
        return Single<Result<Void, RealmRepositoryError>>.create { observer in
            let disposables = Disposables.create()
            
            guard let realmCourseFolder = self.realm.object(
                ofType: CourseFolderTable.self,
                forPrimaryKey: folderId
            ) else {
                observer(.success(.failure(.courseFolderNotFound)))
                return disposables
            }
            
            do {
                try self.realm.write {
                    let realmCourses = realmCourseFolder.courses
                    
                    for realmCourse in realmCourses {
                        self.realm.delete(realmCourse.pins)
                    }
                    
                    self.realm.delete(realmCourses)
                    self.realm.delete(realmCourseFolder)
                }
                observer(.success(.success(())))
            } catch {
                print(#function, error)
                observer(.success(.failure(.writeError)))
            }
            
            return disposables
        }
    }
    
}

//MARK: - Course
extension RealmRepository: CourseRepository {
    
    func fetchCourses() -> [Course] {
        let realmCourses = realm.objects(CourseTable.self)
        return realmCourses.map { $0.transform() }
    }
    
    func fetchCourses(fromFolder folderId: ObjectId) -> [Course] {
        let realmCourses = realm.objects(CourseTable.self)
            .filter { $0.folder.first?._id == folderId }
            .sorted(by: { $0.date > $1.date })
        
        return realmCourses.map { $0.transform() }
    }
    
    func fetchCourse(_ courseId: ObjectId) -> Single<Result<Course, RealmRepositoryError>> {
        return Single<Result<Course, RealmRepositoryError>>.create { observer in
            let disposables = Disposables.create()
            
            guard let realmCourse = self.realm.object(
                ofType: CourseTable.self,
                forPrimaryKey: courseId
            ) else {
                observer(.success(.failure(.courseNotFound)))
                return disposables
            }
            
            let course = realmCourse.transform()
            observer(.success(.success(course)))
            
            return disposables
        }
    }
    
    func addCourse(_ course: Course, toFolder folderId: ObjectId) -> Single<Result<Void, RealmRepositoryError>> {
        return Single<Result<Void, RealmRepositoryError>>.create { observer in
            let disposables = Disposables.create()
            
            guard let realmCourseFolder = self.realm.object(
                ofType: CourseFolderTable.self,
                forPrimaryKey: folderId
            ) else {
                observer(.success(.failure(.courseFolderNotFound)))
                return disposables
            }
            
            let existingCourses = realmCourseFolder.courses
            let hasDuplicateName = existingCourses.contains { $0.title == course.title }
            
            if hasDuplicateName {
                observer(.success(.failure(.duplicateName)))
                return disposables
            }
            
            let realmCourse = course.toNewRealm()
            
            do {
                try self.realm.write {
                    for pin in course.pins {
                        guard let realmPin = pin.toNewRealm() else {
                            observer(.success(.failure(.missingCoordinates)))
                            return
                        }
                        self.realm.add(realmPin)
                        realmCourse.pins.append(realmPin)
                    }
                    
                    self.realm.add(realmCourse)
                    realmCourseFolder.courses.append(realmCourse)
                    realmCourseFolder.date = Date()
                }
                observer(.success(.success(())))
            } catch {
                observer(.success(.failure(.writeError)))
            }
            
            return disposables
        }
    }
    
    func updateCourse(_ course: Course) -> Single<Result<Course, RealmRepositoryError>> {
        return Single<Result<Course, RealmRepositoryError>>.create { observer in
            let disposables = Disposables.create()
            
            guard let realmCourse = self.realm.object(
                ofType: CourseTable.self,
                forPrimaryKey: course._id
            ) else {
                observer(.success(.failure(.courseNotFound)))
                return disposables
            }
            
            guard let realmCurrentCourseFolder = self.realm.object(
                ofType: CourseFolderTable.self,
                forPrimaryKey: realmCourse.folder.first?._id
            ) else {
                observer(.success(.failure(.courseFolderNotFound)))
                return disposables
            }
            
            guard let realmNewCourseFolder = self.realm.object(
                ofType: CourseFolderTable.self,
                forPrimaryKey: course.folder?._id
            ) else {
                observer(.success(.failure(.courseFolderNotFound)))
                return disposables
            }
            
            if realmCurrentCourseFolder._id != realmNewCourseFolder._id {
                let existingCourses = realmNewCourseFolder.courses
                let hasDuplicateName = existingCourses.contains { $0.title == course.title }
                
                guard !hasDuplicateName else {
                    observer(.success(.failure(.duplicateName)))
                    return disposables
                }
            }
            
            do {
                try self.realm.write {
                    // 기본 정보 업데이트
                    realmCourse.image = course.image
                    realmCourse.title = course.title
                    realmCourse.content = course.content
                    realmCourse.duration = course.duration
                    realmCourse.zone = course.zone
                    
                    // 삭제할 핀 처리
                    let existingPins = realmCourse.pins
                    let newPinIds = course.pins.map { $0._id }
                    
                    let pinsToRemove = existingPins.filter { !newPinIds.contains($0._id) }
                    
                    for pin in pinsToRemove {
                        self.realm.delete(pin)
                    }
                    
                    // 새 핀 추가 또는 업데이트
                    for pin in course.pins {
                        if let existingPin = existingPins.first(where: { $0._id == pin._id }) {
                            guard let coord = pin.coord else {
                                print("기존 핀의 위치 정보가 올바르지 않아 건너뜁니다.")
                                continue
                            }
                            
                            // 기존 핀 업데이트
                            existingPin.address = pin.address
                            existingPin.zone = pin.zone
                            existingPin.lat = coord.lat
                            existingPin.lng = coord.lng
                        } else {
                            // 새 핀 추가
                            guard let newPin = pin.toNewRealm() else {
                                print("새로 추가된 핀의 위치 정보가 올바르지 않아 건너뜁니다.")
                                continue
                            }
                            self.realm.add(newPin)
                            realmCourse.pins.append(newPin)
                        }
                    }
                    
                    // 폴더 업데이트
                    if realmCurrentCourseFolder._id != realmNewCourseFolder._id {
                        if let index = realmCurrentCourseFolder.courses.index(of: realmCourse) {
                            realmCurrentCourseFolder.courses.remove(at: index)
                        }
                        
                        realmNewCourseFolder.courses.append(realmCourse)
                        
                        realmCurrentCourseFolder.date = Date()
                        realmNewCourseFolder.date = Date()
                    } else {
                        realmCurrentCourseFolder.date = Date()
                    }
                }
                
                let course = realmCourse.transform()
                observer(.success(.success((course))))
            } catch {
                observer(.success(.failure(.writeError)))
            }
            
            return disposables
        }
    }
    
    func deleteCourse(_ courseId: ObjectId) -> Single<Result<Void, RealmRepositoryError>> {
        return Single<Result<Void, RealmRepositoryError>>.create { observer in
            let disposables = Disposables.create()
            
            guard let realmCourse = self.realm.object(
                ofType: CourseTable.self,
                forPrimaryKey: courseId
            ) else {
                observer(.success(.failure(.courseNotFound)))
                return disposables
            }
            
            do {
                try self.realm.write {
                    self.realm.delete(realmCourse.pins)
                    
                    if let courseFolder = realmCourse.folder.first {
                        if let index = courseFolder.courses.firstIndex(
                            where: { $0._id == realmCourse._id }
                        ) {
                            courseFolder.courses.remove(at: index)
                        }
                        
                        courseFolder.date = Date()
                    }
                    
                    self.realm.delete(realmCourse)
                }
                observer(.success(.success(())))
            } catch {
                observer(.success(.failure(.writeError)))
            }
            
            return disposables
        }
    }
    
}
