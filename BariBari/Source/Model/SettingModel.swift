//
//  SettingModel.swift
//  BariBari
//
//  Created by Goo on 4/21/25.
//

import Foundation

//MARK: - About

//MARK: - About
enum AppInfoVersionType: CaseIterable {
    static let title = C.appVersionSectionTitle
    
    case app
    
    var icon: AppIcon {
        switch self {
        case .app:
            return AppIcon.tag
        }
    }
    
    var title: String {
        switch self {
        case .app:
            return "앱 버전"
        }
    }
    
    var subText: String {
        switch self {
        case .app:
            return C.version
        }
    }
}

enum AppInfoLinkType: CaseIterable {
    static let title = C.appInfoSectionTitle
    
    case mail
    case appStore
    case privacyPolicy
    
    var icon: AppIcon {
        switch self {
        case .mail:
            return AppIcon.mail
        case .appStore:
            return AppIcon.star
        case .privacyPolicy:
            return AppIcon.lock
        }
    }
    
    var title: String {
        switch self {
        case .mail:
            return "개발자에게 메일로 피드백 보내기"
        case .appStore:
            return "앱 스토어에서 앱 평가하기"
        case .privacyPolicy:
            return "개인 정보 정책"
        }
    }
}

enum AppCreditThanksType: CaseIterable {
    static let title = C.appCreditThanksTitle
    
    case unsplashAPI
    
    var icon: AppIcon {
        return AppIcon.heart
    }
    
    var title: String {
        switch self {
        case .unsplashAPI:
            return "Unsplash API"
        }
    }
}
