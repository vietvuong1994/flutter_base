//
//  Utils.swift
//  iOS Structure MVC
//
//  Created by kien on 10/9/18.
//  Copyright © 2018 kien. All rights reserved.
//
import Foundation
import UIKit

class GeneralUtils {
    // Check sandbox enviroment or not
    #if DEVELOP || STAGING
    static let isSandboxEnviroment: Bool = true
    #else
    static let isSandboxEnviroment: Bool = false
    #endif
    
    // Get/set value for app icon badge value
    static var appIconValue: Int {
        get {
            return UIApplication.shared.applicationIconBadgeNumber
        }
        set(value) {
            UIApplication.shared.applicationIconBadgeNumber = value
        }
    }
    
    // Main queue
    static func mainQueue(closure: @escaping () -> Void) {
        DispatchQueue.main.async {
            closure()
        }
    }
    
    // Sleep app with input time interval
    static func sleep(_ second: TimeInterval, completion: @escaping (() -> Void)) {
        DispatchQueue.main.asyncAfter(deadline: .now() + second, execute: {
            completion()
        })
    }
    
    static func openUrl(string: String) {
        guard let url = URL(string: string) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    static func openAppOnAppStore() {
        guard let url = SystemUtils.appUrlOnAppStore else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    static func needToUpdateAppWith(remoteVersion: String) -> Bool {
        guard let currentVersion = SystemUtils.appVersion else { return false }
        return remoteVersion.compare(currentVersion, options: .numeric) == .orderedDescending
    }
    
    static func isIpad() -> Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
}
