//
//  SystemInfo.swift
//  iOS Structure MVC
//
//  Created by Vinh Dang on 10/29/18.
//  Copyright © 2018 kien. All rights reserved.
//

import UIKit

// MARK: - App general information
class SystemUtils {
    static let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ?? ""
    static let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    static let appBuildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
    static let schemeName = ProcessInfo.processInfo.environment["targetName"] ?? ""
    static let osName = UIDevice.current.systemName
    static let osVersion = UIDevice.current.systemVersion
    static let uuid = UUID().uuidString
    static var bundleId: String? {
        return Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String
    }
    static let appIdOnAppStore: String = "1345230870" // Replace with app id on AppstoreConnect
    static var appUrlOnAppStore: URL? {
        let urlStr = String(format: "itms-apps://itunes.apple.com/app/bars/id%@", appIdOnAppStore)
        return URL(string: urlStr)
    }
    
    static func getDarkModeDetect() -> Bool {
        if #available(iOS 13, *) {
            if UITraitCollection().userInterfaceStyle == .dark {
                /// Return the color for Dark Mode
                return true
            } else {
                /// Return the color for Light Mode
                return false
            }
        } else {
            /// Return a fallback color for iOS 12 and lower.
            return false
        }
    }
    
    static func openAppStore() {
         guard let urlAppStore = appUrlOnAppStore else {
             return
         }
         if #available(iOS 10.0, *) {
             UIApplication.shared.open(urlAppStore, options: [:], completionHandler: nil)

         } else {
             UIApplication.shared.openURL(urlAppStore)
         }
     }
}

// MARK: - Encoding
extension SystemUtils {
    static let shiftJISEncoding = String.Encoding.shiftJIS
    static let utf8Encoding = String.Encoding.utf8
}
