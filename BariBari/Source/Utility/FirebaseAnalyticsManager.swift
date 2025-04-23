//
//  FirebaseAnalyticsManager.swift
//  BariBari
//
//  Created by Goo on 4/23/25.
//

import Foundation
import FirebaseAnalytics

protocol FirebaseAnalyticsProtocol {
    func logScreenView(_ viewController: BaseViewController)
    func logEventInScreen(action: ActionType, screen: ScreenType, additionalParams: [String: Any]?)
    func logEvent(action: ActionType, additionalParams: [String: Any]?)
}

enum ScreenType: String {
    case home
    case homeDetail
    
    case about
    case setting
    
    case createCourseFolder
    case createFrom
    case createList
    case createTracking
    case createTrackingModal
    case createAuto
    
    case storageEntireCourse
    case storageCourse
    case storageCourseDetail
    case storageCourseDetailMapPicker
    
    case modal
}

enum ActionType: String {
    case tabHome
    case tabCreate
    case tabStorage
    
    case homeMore
    case homeBanner
    case homeCourse
    
    case about
    
    case settingReset
    
    case homeDetailMap
    
    case createTrackingQuit
    case createTrackingStart
    case createTrackingStop
    case createTrackingSave
    
    case createFolderImage
    case createFolderTitle
    case createFolderContent
    case createTemporaryFolder
    
    case createFormCourseFolder
    case createFormImage
    case createFormTitle
    case createFormContent
    case createFormQuit
    case createFormSave
    case createFormEdit
    
    case storageEntireDelete
    case storageEntireLongPress
    case storageCourseFolderEdit
    case storageCourseDetailEdit
    case storageCourseDetailDelete
    case storageCourseDetailMap
    
    case openMap
    
    case trackingInBackground
    case trackingBecameForeground
    
    case addCourseFolder
    case updateCourseFolder
    case deleteCourseFolder
    case addCourse
    case updateCourse
    case deleteCourse
}

final class FirebaseAnalyticsManager: FirebaseAnalyticsProtocol {
    
    static let shared = FirebaseAnalyticsManager()
    
    private init() {}
    
    func logScreenView(_ viewController: BaseViewController) {
        let screenName = String(describing: type(of: viewController))
        
        Analytics.logEvent(AnalyticsEventScreenView, parameters: [
            AnalyticsParameterScreenName: screenName,
            AnalyticsParameterScreenClass: screenName
        ])
        
        print("📊 ScreenView logged: \(screenName)")
    }
    
    func logEventInScreen(
        action: ActionType,
        screen: ScreenType,
        additionalParams: [String: Any]? = nil
    ) {
        var params: [String: Any] = [
            "action": action.rawValue,
            "screen": screen.rawValue
        ]
        
        if let extra = additionalParams {
            params.merge(extra) { _, new in new }
        }
        
        Analytics.logEvent("event_in_screen", parameters: params)
        
        print("📊 event_in_screen logged: \(params)")
    }
    
    func logEvent(action: ActionType, additionalParams: [String: Any]? = nil) {
        var params: [String: Any] = [
            "action": action.rawValue
        ]
        
        if let extra = additionalParams {
            params.merge(extra) { _, new in new }
        }
        
        Analytics.logEvent("action", parameters: params)
        print("📊 event logged: \(params)")
    }
    
}
