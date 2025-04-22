//
//  AboutModel.swift
//  BariBari
//
//  Created by Goo on 4/21/25.
//

import Foundation

enum AboutSection: SectionProtocol {
    case version
    case link
    case creditThanks
    
    var value: SectionModel {
        switch self {
        case .version:
            return SectionType.makeSectionModel(item: AboutVersionType.self)
        case .link:
            return SectionType.makeSectionModel(item: AboutLinkType.self)
        case .creditThanks:
            return SectionType.makeSectionModel(item: AboutCreditThanksType.self)
        }
    }
}

enum AboutVersionType: SectionItemProtocol {
    static let sectionTitle: String = "VERSION"
    
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
    
    var subText: String? {
        switch self {
        case .app:
            guard let dictionary = Bundle.main.infoDictionary,
                  let version = dictionary["CFBundleShortVersionString"] as? String
            else { return "-.-.-" }
            
            return version
        }
    }
    
    var url: URL? {
        return nil
    }
    
    var isMoreIcon: Bool {
        return false
    }
}

enum AboutLinkType: SectionItemProtocol {
    static let sectionTitle: String = "THE APP"
    
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
    
    var subText: String? {
        return nil
    }
    
    var url: URL? {
        switch self {
        case .mail:
            return URL(string: C.mailURL)
        case .appStore:
            guard let appStoreURL = URL(string: C.appStoreURL) else {
                return nil
            }
            
            var components = URLComponents(url: appStoreURL, resolvingAgainstBaseURL: false)
            
            components?.queryItems = [
                URLQueryItem(name: "action", value: "write-review")
            ]
            
            return components?.url
        case .privacyPolicy:
            return URL(string: C.privacyPolicyURL)
        }
    }
    
    var isMoreIcon: Bool {
        return false
    }
    
}

enum AboutCreditThanksType: SectionItemProtocol {
    static let sectionTitle: String = "CREDIT / THANKS"
    
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
    
    var subText: String? {
        return nil
    }
    
    var url: URL? {
        switch self {
        case .unsplashAPI:
            return URL(string: C.unsplashURL)
        }
    }
    
    var isMoreIcon: Bool {
        return false
    }
}
