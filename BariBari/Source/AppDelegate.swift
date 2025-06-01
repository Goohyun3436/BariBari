//
//  AppDelegate.swift
//  BariBari
//
//  Created by Goo on 3/18/25.
//

import UIKit
import RealmSwift
import FirebaseCore
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        migration()
        
        FirebaseApp.configure()
        
        AppAppearance.setupAppearance()
        
        IQKeyboardManager.shared.isEnabled = true
        IQKeyboardManager.shared.resignOnTouchOutside = true
        
        Thread.sleep(forTimeInterval: 2.0)
        
        return true
    }
    
    private func migration() {
        let defaultRealm = Realm.Configuration.defaultConfiguration.fileURL!
        let container = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: C.appGroupID)
        let realmURL = container?.appendingPathComponent(C.realmPath)
        var config: Realm.Configuration!
        
        if FileManager.default.fileExists(atPath: defaultRealm.path) {
            do {
                _ = try FileManager.default.replaceItemAt(realmURL!, withItemAt: defaultRealm)
                config = RealmRepository.config
            } catch {
                print("Error info: \(error)")
            }
        } else {
            config = RealmRepository.config
        }
        
        Realm.Configuration.defaultConfiguration = config
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
}

