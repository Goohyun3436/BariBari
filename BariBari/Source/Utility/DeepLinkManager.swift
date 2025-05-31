//
//  DeepLinkManager.swift
//  BariBari
//
//  Created by Goo on 5/31/25.
//

import UIKit
import RxSwift
import RealmSwift

final class DeepLinkManager {
    
    static let shared = DeepLinkManager()
    
    private let disposeBag = DisposeBag()
    
    func link(_ url: URL) {
        guard url.scheme == C.appUrlScheme else { return }
        
        let pathComponents = url.pathComponents
        let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems
        
        guard pathComponents.count >= 3 else { return }
        
        if url.host == "storage", pathComponents[2] == "course" {
            let tabID = 2
            
            guard let window = UIApplication.shared.connectedScenes
                .compactMap({ ($0 as? UIWindowScene)?.keyWindow }).first,
                  let tabBarController = window.rootViewController as? UITabBarController,
                  let storageNav = tabBarController.viewControllers?[tabID] as? UINavigationController,
                  let courseIDString = queryItems?.first(where: { $0.name == "id" })?.value
            else { return }
            
            do {
                let folderID = try ObjectId(string: pathComponents[1])
                let courseID = try ObjectId(string: courseIDString)
                
                let folderSingle = RealmRepository.shared.fetchCourseFolder(folderID)
                let courseSingle = RealmRepository.shared.fetchCourse(courseID)
                
                Single.zip(folderSingle, courseSingle)
                    .observe(on: MainScheduler.instance)
                    .flatMap { folderResult, courseResult -> Single<(CourseFolder, Course)> in
                        switch (folderResult, courseResult) {
                        case let (.success(folder), .success(course)):
                            return .just((folder, course))
                        case let (.failure(error), _):
                            return .error(error)
                        case let (_, .failure(error)):
                            return .error(error)
                        }
                    }
                    .subscribe(onSuccess: { folder, course in
                        tabBarController.selectedIndex = tabID
                        storageNav.popToRootViewController(animated: false)
                        
                        let entireVC = EntireCourseViewController()
                        let folderVC = CourseViewController(viewModel: CourseViewModel(
                            courseFolder: folder
                        ))
                        let detailVC = CourseDetailViewController(viewModel: CourseDetailViewModel(
                            courseFolder: folder,
                            course: course
                        ))
                        
                        storageNav.setViewControllers([entireVC, folderVC, detailVC], animated: true)
                    }, onFailure: { error in
                        print("DeepLink 처리 실패:", error)
                    })
                    .disposed(by: disposeBag)
            } catch {
                FirebaseAnalyticsManager.shared.logEvent(
                    action: .deepLink,
                    additionalParams: [
                        "error": error.localizedDescription
                    ]
                )
            }
        }
    }
}
