//
//  SettingModel.swift
//  BariBari
//
//  Created by Goo on 4/22/25.
//

import Foundation

enum SettingSection: SectionProtocol {
    case system
    
    var value: SectionModel {
        switch self {
        case .system:
            return SectionType.makeSectionModel(item: SettingSystemType.self)
        }
    }
}


enum SettingSystemType: SectionItemProtocol {
    static let sectionTitle: String = "SYSTEM"
    
    case reset
    
    var icon: AppIcon {
        switch self {
        case .reset:
            return AppIcon.warning
        }
    }
    
    var title: String {
        switch self {
        case .reset:
            return "코스 보관함 데이터 초기화"
        }
    }
    
    var subText: String? {
        return nil
    }
    
    var url: URL? {
        return nil
    }
    
    var isMoreIcon: Bool {
        return false
    }
}
