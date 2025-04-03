//
//  RealmRepository.swift
//  BariBari
//
//  Created by Goo on 3/29/25.
//

import Foundation
import RealmSwift

final class RealmRepository {
    
    private let realm = try! Realm()
    
    static let shared = RealmRepository()
    
    func printFileURL() {
        print(realm.configuration.fileURL ?? "NotFound fileURL")
    }
    
}

//MARK: - CourseFolder
extension RealmRepository: CourseFolderRepository {
    
    func fetchCourseFolders() -> [CourseFolder] {
//        let realmCourseFolders = realm.objects(CourseFolderTable.self)
//        return realmCourseFolders.map { $0.transform() }
        
//        return [
//            CourseFolderTable(image: "", title: "나중에 가보고 싶은 코스"),
//            CourseFolderTable(image: "", title: "낮에 가면 좋은 코스"),
//            CourseFolderTable(image: "", title: "밤바리"),
//            CourseFolderTable(image: "", title: "나중에 로얄엔필드로 기변하면 가봐야지")
//        ].map { $0.transform() }
        
        return []
    }
    
    func fetchCourseFolder(_ folderId: ObjectId) -> CourseFolder? {
        guard let realmCourseFolders = realm.object(
            ofType: CourseFolderTable.self,
            forPrimaryKey: folderId
        ) else {
            print("폴더를 찾을 수 없습니다.")
            return nil
        }
        return realmCourseFolders.transform()
    }
    
    func addCourseFolder(_ folder: CourseFolder) {
        let realmCourseFolders = folder.toNewRealm()
        
        do {
            try realm.write {
                realm.add(realmCourseFolders)
            }
        } catch {
            print(#function, error)
        }
    }
    
    func updateCourseFolder(_ folder: CourseFolder) {
        guard let realmCourseFolders = realm.object(
            ofType: CourseFolderTable.self,
            forPrimaryKey: folder._id
        ) else {
            print("폴더를 찾을 수 없습니다.")
            return
        }
        
        do {
            try realm.write {
                realmCourseFolders.image = folder.image
                realmCourseFolders.title = folder.title
            }
        } catch {
            print(#function, error)
        }
    }
    
    func deleteCourseFolder(_ folderId: ObjectId) {
        guard let realmCourseFolders = realm.object(
            ofType: CourseFolderTable.self,
            forPrimaryKey: folderId
        ) else {
            print("폴더를 찾을 수 없습니다.")
            return
        }
        
        do {
            try realm.write {
                let realmCourses = realmCourseFolders.courses
                
                for realmCourse in realmCourses {
                    realm.delete(realmCourse.pins)
                }
                
                realm.delete(realmCourses)
                
                realm.delete(realmCourseFolders)
            }
        } catch {
            print(#function, error)
        }
    }
    
}

//MARK: - Course
extension RealmRepository: CourseRepository {
    
    func fetchCourses() -> [Course] {
        let realmCourses = realm.objects(CourseTable.self)
        return realmCourses.map { $0.transform() }
    }
    
    func fetchCourse(_ courseId: ObjectId) -> Course? {
        guard let realmCourse = realm.object(
            ofType: CourseTable.self,
            forPrimaryKey: courseId
        ) else {
            return nil
        }
        return realmCourse.transform()
    }
    
    func addCourse(_ course: Course, toFolder folderId: RealmSwift.ObjectId) {
        guard let realmCourseFolder = realm.object(
            ofType: CourseFolderTable.self,
            forPrimaryKey: folderId
        ) else {
            return
        }
        
        let realmCourse = course.toNewRealm()
        
        do {
            try realm.write {
                for pin in course.pins {
                    guard let realmPin = pin.toNewRealm() else {
                        print("위경도 정보가 없습니다.")
                        return
                    }
                    realm.add(realmPin)
                    realmCourse.pins.append(realmPin)
                }
                
                realm.add(realmCourse)
                realmCourseFolder.courses.append(realmCourse)
            }
        } catch {
            print(#function, error)
        }
    }
    
    func updateCourse(_ course: Course) {
        guard let realmCourse = realm.object(
            ofType: CourseTable.self,
            forPrimaryKey: course._id
        ) else {
            print("코스를 찾을 수 없습니다.")
            return
        }
        
        do {
            try realm.write {
                // 기본 정보 업데이트
                realmCourse.image = course.image
                realmCourse.title = course.title
                realmCourse.content = course.content
                realmCourse.duration = course.duration
                realmCourse.zone = course.zone
                
                // 핀 관리
                let existingPins = realmCourse.pins
                let newPinIds = course.pins.map { $0._id }
                
                // 삭제할 핀 찾기
                let pinsToRemove = existingPins.filter { !newPinIds.contains($0._id) }
                
                // 핀 제거
                for pin in pinsToRemove {
                    realm.delete(pin)
                }
                
                // 새 핀 추가 또는 업데이트
                for pin in course.pins {
                    if let existingPin = existingPins.first(where: { $0._id == pin._id }) {
                        guard let coord = pin.coord else {
                            print("기존 핀의 위치 정보가 없어서 건너뜁니다.")
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
                            print("새로 추가된 핀의 위치 정보가 없어서 건너뜁니다.")
                            continue
                        }
                        realm.add(newPin)
                        realmCourse.pins.append(newPin)
                    }
                }
            }
        } catch {
            print(#function, error)
        }
    }
    
    func deleteCourse(_ courseId: ObjectId) {
        guard let realmCourse = realm.object(
            ofType: CourseTable.self,
            forPrimaryKey: courseId
        ) else {
            print("코스를 찾을 수 없습니다.")
            return
        }
        
        do {
            try realm.write {
                realm.delete(realmCourse.pins)
                
                if let courseFolder = realmCourse.folder.first {
                    if let index = courseFolder.courses.firstIndex(
                        where: { $0._id == realmCourse._id }
                    ) {
                        courseFolder.courses.remove(at: index)
                    }
                }
                
                realm.delete(realmCourse)
            }
        } catch {
            print(#function, error)
        }
    }
    
}
