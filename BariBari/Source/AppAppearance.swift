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
    case lightGray
    case blue
    case overlay
    case clear
    
    var value: UIColor {
        switch self {
        case .white:
            return UIColor.white
        case .black:
            return UIColor.black
        case .gray:
            return UIColor.appGray
        case .lightGray:
            return UIColor.appLightGray
        case .blue:
            return UIColor.appBlue
        case .overlay:
            return UIColor.appOverlay
        case .clear:
            return UIColor.clear
        }
    }
}

enum AppFont {
    case logo
    case largeTitle
    case title1
    case title2
    case title3
    case title4
    case text1
    case text2
    case subText1
    case subText2
    case subText3
    
    var value: UIFont {
        switch self {
        case .logo:
            return UIFont.italicSystemFont(ofSize: 28)
        case .largeTitle:
            return UIFont.systemFont(ofSize: 20, weight: .bold)
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
        case .subText1:
            return UIFont.systemFont(ofSize: 10, weight: .bold)
        case .subText2:
            return UIFont.systemFont(ofSize: 9, weight: .bold)
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
    case arrowDown
    case menu
    case plus
    case camera
    case folder
    
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
        case .arrowDown:
            return "chevron.down"
        case .menu:
            return "line.3.horizontal.decrease"
        case .plus:
            return "plus"
        case .camera:
            return "camera.fill"
        case .folder:
            return "folder.fill"
        }
    }
}

enum AppImage {
    case createTracking
    
    var value: String {
        switch self {
        case .createTracking:
            return "createTracking"
        }
    }
}

final class AppAppearance {
    
    static func setupAppearance() {
        let appearanceTB = UITabBarAppearance()
        appearanceTB.configureWithTransparentBackground()
        appearanceTB.shadowColor = AppColor.gray.value
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
        appearanceNB.shadowColor = AppColor.gray.value
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
        
        UICollectionView.appearance().backgroundColor = AppColor.white.value
        BaseCollectionViewCell.appearance().backgroundColor = AppColor.white.value
        
        MKMapView.appearance().overrideUserInterfaceStyle = .light
    }
    
}
