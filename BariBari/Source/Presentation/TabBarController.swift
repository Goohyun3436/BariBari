//
//  TabBarController.swift
//  BariBari
//
//  Created by Goo on 3/29/25.
//

import UIKit

private enum TabBar: String, CaseIterable {
    case storage
    case home
    case create
    
    var vc: UIViewController.Type {
        switch self {
        case .home:
            return HomeViewController.self
        case .create:
            return CreateListViewController.self
        case .storage:
            return EntireCourseViewController.self
        }
    }
    
    var navigationTitle: String {
        switch self {
        case .home:
            return "바리바리"
        case .create:
            return "코스 생성"
        case .storage:
            return "코스 보관함"
        }
    }
    
    var title: String {
        switch self {
        case .home:
            return "홈"
        case .create:
            return "코스 생성"
        case .storage:
            return "코스 보관함"
        }
    }
    
    var icon: String {
        switch self {
        case .home:
            return AppIcon.home.value
        case .create:
            return AppIcon.create.value
        case .storage:
            return AppIcon.storage.value
        }
    }
}

final class TabBarController: UITabBarController {
    
    //MARK: - Override Method
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTBC()
    }
    
    //MARK: - Setup Method
    private func setupTBC() {
        view.backgroundColor = UIColor.white
        view.tintColor = UIColor.black
        
        let tabs = TabBar.allCases
        var navs = [UINavigationController]()
        
        for item in tabs {
            navs.append(makeNav(item))
        }
        
        setViewControllers(navs, animated: true)
    }
    
    //MARK: - Method
    private func makeNav(_ tab: TabBar) -> UINavigationController {
        let vc = tab.vc.init()
        let nav = UINavigationController(rootViewController: vc)
        vc.navigationItem.title = tab.navigationTitle
        nav.tabBarItem.image = UIImage(
            systemName: tab.icon,
            withConfiguration: UIImage.SymbolConfiguration(
                font: AppFont.title2.value
            )
        )
        nav.tabBarItem.title = tab.title
        return nav
    }
    
}
