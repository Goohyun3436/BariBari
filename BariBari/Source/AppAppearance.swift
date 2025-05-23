//
//  AppAppearance.swift
//  BariBari
//
//  Created by Goo on 4/2/25.
//

import UIKit
import MapKit

enum AppColor {
    case white
    case black
    case gray
    case darkGray
    case lightGray
    case blue
    case red
    case overlay
    case border
    case clear
    
    var value: UIColor {
        switch self {
        case .white:
            return UIColor.white
        case .black:
            return UIColor.black
        case .gray:
            return UIColor.appGray
        case .darkGray:
            return UIColor.appDarkGray
        case .lightGray:
            return UIColor.appLightGray
        case .blue:
            return UIColor.appBlue
        case .red:
            return UIColor.appRed
        case .overlay:
            return UIColor.appOverlay
        case .border:
            return UIColor.appBorder
        case .clear:
            return UIColor.clear
        }
    }
}

enum AppFont {
    case logo
    case largeIcon
    case largeTitle
    case largeTitleRegular
    case title1
    case title2
    case title3
    case title4
    case text1
    case text2
    case text3
    case subText1
    case subText2
    case subText3
    
    var value: UIFont {
        switch self {
        case .logo:
            return UIFont.italicSystemFont(ofSize: 28)
        case .largeIcon:
            return UIFont.systemFont(ofSize: 24)
        case .largeTitle:
            return UIFont.systemFont(ofSize: 20, weight: .bold)
        case .largeTitleRegular:
            return UIFont.systemFont(ofSize: 20)
        case .title1:
            return UIFont.systemFont(ofSize: 16, weight: .bold)
        case .title2:
            return UIFont.systemFont(ofSize: 14, weight: .bold)
        case .title3:
            return UIFont.systemFont(ofSize: 13, weight: .bold)
        case .title4:
            return UIFont.systemFont(ofSize: 13)
        case .text1:
            return UIFont.systemFont(ofSize: 12, weight: .bold)
        case .text2:
            return UIFont.systemFont(ofSize: 12)
        case .text3:
            return UIFont.systemFont(ofSize: 11)
        case .subText1:
            return UIFont.systemFont(ofSize: 10, weight: .bold)
        case .subText2:
            return UIFont.systemFont(ofSize: 10)
        case .subText3:
            return UIFont.systemFont(ofSize: 9)
        }
    }
}

enum AppIcon {
    case home
    case create
    case storage
    case arrowLeft
    case arrowRight
    case arrowDown
    case menu
    case more
    case plus
    case tag
    case camera
    case folder
    case map
    case pin
    case calendar
    case mail
    case star
    case lock
    case heart
    case edit
    case delete
    case check
    case warning
    case xmark
    
    var value: String {
        switch self {
        case .home:
            return "house.fill"
        case .create:
            return "mappin.and.ellipse"
        case .storage:
            return "archivebox.fill"
        case .arrowLeft:
            return "arrow.left"
        case .arrowRight:
            return "chevron.right"
        case .arrowDown:
            return "chevron.down"
        case .menu:
            return "line.3.horizontal.decrease"
        case .more:
            return "ellipsis.circle"
        case .plus:
            return "plus"
        case .tag:
            return "tag"
        case .camera:
            return "camera.fill"
        case .folder:
            return "folder.fill"
        case .map:
            return "map.fill"
        case .pin:
            return "pin.fill"
        case .calendar:
            return "calendar"
        case .mail:
            return "envelope.fill"
        case .star:
            return "star.fill"
        case .lock:
            return "lock.fill"
        case .heart:
            return "heart.fill"
        case .edit:
            return "pencil.circle"
        case .delete:
            return "trash.circle"
        case .check:
            return "checkmark.circle"
        case .warning:
            return "exclamationmark.triangle.fill"
        case .xmark:
            return "xmark.circle.fill"
        }
    }
}

enum AppImage {
    case createTracking
    case naverMap
    
    var value: String {
        switch self {
        case .createTracking:
            return "createTracking"
        case .naverMap:
            return "NMap"
        }
    }
}

final class AppAppearance {
    
    static func setupAppearance() {
        let appearanceTB = UITabBarAppearance()
        appearanceTB.configureWithTransparentBackground()
        appearanceTB.shadowColor = AppColor.border.value
        appearanceTB.backgroundColor = AppColor.white.value
        UITabBar.appearance().tintColor = AppColor.black.value
        UITabBar.appearance().standardAppearance = appearanceTB
        UITabBar.appearance().scrollEdgeAppearance = appearanceTB
        
        let appearanceTBI = UITabBarItemAppearance()
        let titleAttributesTBI = [NSAttributedString.Key.font: AppFont.subText1.value]
        appearanceTBI.normal.titleTextAttributes = titleAttributesTBI
        appearanceTBI.selected.titleTextAttributes = titleAttributesTBI
        appearanceTB.stackedLayoutAppearance = appearanceTBI
        
        let appearanceNB = UINavigationBarAppearance()
        let titleAttributesNB = [
            NSAttributedString.Key.foregroundColor: AppColor.black.value,
            NSAttributedString.Key.font: AppFont.title1.value
        ]
        let backButtonImage = UIImage(systemName: AppIcon.arrowLeft.value)
        appearanceNB.configureWithTransparentBackground()
        appearanceNB.shadowColor = AppColor.border.value
        appearanceNB.backgroundColor = AppColor.white.value
        appearanceNB.titleTextAttributes = titleAttributesNB
        appearanceNB.largeTitleTextAttributes = titleAttributesNB
        appearanceNB.setBackIndicatorImage(backButtonImage, transitionMaskImage: backButtonImage)
        UINavigationBar.appearance().tintColor = AppColor.black.value
        UINavigationBar.appearance().standardAppearance = appearanceNB
        UINavigationBar.appearance().scrollEdgeAppearance = appearanceNB
        UINavigationBar.appearance().compactAppearance = appearanceNB
        
        BaseView.appearance().backgroundColor = AppColor.white.value
        
        UITextField.appearance().tintColor = AppColor.black.value
        UITextField.appearance().textColor = AppColor.black.value
        UITextField.appearance().backgroundColor = AppColor.lightGray.value
        UITextField.appearance().font = AppFont.text2.value
        
        UITextView.appearance().tintColor = AppColor.black.value
        UITextView.appearance().textColor = AppColor.black.value
        UITextView.appearance().backgroundColor = AppColor.lightGray.value
        UITextView.appearance().font = AppFont.text2.value
        
        UISearchBar.appearance().barTintColor = AppColor.white.value
        UISearchBar.appearance().keyboardAppearance = UIKeyboardAppearance.light
        UISearchTextField.appearance().tintColor = AppColor.black.value
        
        UITableView.appearance().backgroundColor = AppColor.white.value
        BaseTableViewCell.appearance().backgroundColor = AppColor.white.value
        
        UICollectionView.appearance().backgroundColor = AppColor.white.value
        BaseCollectionViewCell.appearance().backgroundColor = AppColor.white.value
        
        MKMapView.appearance().overrideUserInterfaceStyle = .light
    }
    
}
