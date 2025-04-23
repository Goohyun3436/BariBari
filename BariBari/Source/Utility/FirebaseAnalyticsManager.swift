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
    func logEvent(action: ActionType, parameters: [String: Any]?)
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
    case homeAbout
    case homeSetting
    case homeBanner
    case homeDetail
    
    case aboutVersion
    case aboutMail
    case aboutAppStore
    case aboutPrivacyPolicy
    case aboutUnsplashAPI
    
    case settingReset
    
    case homeDetailMap
    
    case createTrackingQuit
    case createTrackingStart
    case createTrackingBottomBar
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
    case storageCourseFolder
    case storageCourseFolderEdit
    case storageCourse
    case storageCourseDetailEdit
    case storageCourseDetailDelete
    case storageCourseDetailMap
    
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
        
        Analytics.logEvent("button_tap", parameters: params)
        
        print("📊 Button Tap logged: \(action.rawValue) on \(params["screen"] ?? "")")
    }
    
    func logEvent(action: ActionType, parameters: [String: Any]? = nil) {
        Analytics.logEvent(action.rawValue, parameters: parameters)
        print("📊 Custom event logged: \(action.rawValue), params: \(parameters ?? [:])")
    }
    
}
