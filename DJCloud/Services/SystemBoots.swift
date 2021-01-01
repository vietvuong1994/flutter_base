//
//  SystemBoots.swift
//  iOS Structure MVC
//
//  Created by kien on 10/9/18.
//  Copyright © 2018 kien. All rights reserved.
//

import UIKit

class SystemBoots {
    
    // MARK: - Singleton
    static let instance = SystemBoots()
        
    // MARK: - Actions
    func changeRoot(window: inout UIWindow?, rootController: UIViewController) {
        // Setup app's window
        guard window == nil else {
            window?.rootViewController = rootController
            window?.makeKeyAndVisible()
            return
        }
        window = UIWindow(frame: ScreenUtils.screenBounds)
        window?.backgroundColor = .white
        window?.rootViewController = rootController
        window?.makeKeyAndVisible()
    }
    
    func changeRoot(rootController: UIViewController) {
        let opt = UIWindow.TransitionOptions(direction: .fade, style: .easeOut)
        UIApplication.shared.keyWindow?.setRootViewController(rootController, options: opt)
    }
}
