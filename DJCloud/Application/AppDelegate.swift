//
//  AppDelegate.swift
//  DJCloud
//
//  Created by kien on 9/12/20.
//  Copyright © 2020 kienpt. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import GoogleSignIn
import Firebase
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var user: User?
    
    // MARK: - Constants
    static let shared = UIApplication.shared.delegate as? AppDelegate

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        #if compiler(>=5.1)
        if #available(iOS 13.0, *) {
            // Always adopt a light interface style.
            window?.overrideUserInterfaceStyle = .light
        }
        #endif
        if #available(iOS 13.0, *) {
            // DO NOTHING
        } else {
            let loadingVC = LoadingVC.create()
            SystemBoots.instance.changeRoot(window: &window, rootController: loadingVC)
        }
//        UIBarButtonItem.appearance().tintColor = UIColor.yellow
        UITabBar.appearance().tintColor = UIColor.appColor(.ColorTintApp)
//        UITabBar.appearance().barTintColor = UIColor.appColor(.ColorBackGroundTab)
        basicAppConfig()
        return true
    }
    
    private func basicAppConfig() {
        if let filePath = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist"),
            let options = FirebaseOptions(contentsOfFile: filePath) {
            FirebaseApp.configure(options: options)
        }
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
    }
    
    func application( _ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:] ) -> Bool {
       let fb = ApplicationDelegate.shared.application( app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation] )
        let gg = GIDSignIn.sharedInstance()?.handle(url)
        return fb || (gg != nil)
    }

    // MARK: UISceneSession Lifecycle
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

