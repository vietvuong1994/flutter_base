//
//  SharedData.swift
//  DJCloud
//
//  Created by kien on 10/24/20.
//  Copyright © 2020 kienpt. All rights reserved.
//

import Foundation

// MARK: - General information
class SharedData {
    class var accessToken: String? {
        get {
            return (UserDefaults.standard.value(forKey: "ApiAccessToken") as? String)
        }
        set(value) {
            UserDefaults.standard.set(value, forKey: "ApiAccessToken")
        }
    }
    
    class var userNameDisplay: String? {
        get {
            return (UserDefaults.standard.value(forKey: "UserNameDisplay") as? String)
        }
        set(value) {
            UserDefaults.standard.set(value, forKey: "UserNameDisplay")
        }
    }
    
    class var avatarUser: String? {
        get {
            return (UserDefaults.standard.value(forKey: "UserAvatarUrl") as? String)
        }
        set(value) {
            UserDefaults.standard.set(value, forKey: "UserAvatarUrl")
        }
    }
    
    class var userName: String? {
       get {
            return (UserDefaults.standard.value(forKey: "UserName") as? String)
        }
        set(value) {
            UserDefaults.standard.set(value, forKey: "UserName")
        }
    }
    
    class var firstRunApp: Bool {
        get {
            return (UserDefaults.standard.bool(forKey: "FirstRunApp"))
        }
        set(value) {
            UserDefaults.standard.set(value, forKey: "FirstRunApp")
        }
    }
}
