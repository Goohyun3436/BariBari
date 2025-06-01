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
    case createForm
    case createList
    case createTracking
    case createTrackingModal
    case createAuto
    
    case storageEntireCourse
    case storageCourse
    case storageCourseDetail
    
    case courseDetailMapPicker
    
    case modal
}

enum ActionType: String {
    case homeMore
    case homeBanner
    case homeCourse
    
    case about
    case setting
    
    case homeDetailMap
    
    case createTrackingQuit
    case createTrackingStart
    case createTrackingStop
    case createTrackingSave
    
    case createFolderImage
    case createFolderQuit
    case createFolderSave
    
    case createFormCourseFolder
    case createFormImage
    case createFormQuit
    case createFormSave
    case createFormEdit
    
    case storageEntireDelete
    case storageEntireLongPress
    case storageCourseFolderEdit
    case storageCourseDetailEdit
    case storageCourseDetailDelete
    case storageCourseDetailMap
    
    case openNaverMap
    
    case trackingInBackground
    case trackingBecameForeground
    
    case reset
    case addTemporaryCourseFolder
    case addCourseFolder
    case updateCourseFolder
    case deleteCourseFolder
    case addCourse
    case updateCourse
    case deleteCourse
    
    case deepLink
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
    }
    
    func logEvent(action: ActionType, additionalParams: [String: Any]? = nil) {
        var params: [String: Any] = [
            "action": action.rawValue
        ]
        
        if let extra = additionalParams {
            params.merge(extra) { _, new in new }
        }
        
        Analytics.logEvent("action", parameters: params)
    }
    
}
