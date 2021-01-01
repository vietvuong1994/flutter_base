//
//  NotificationPermission.swift
//  iOS Structure MVC
//
//  Created by kien on 2/19/19.
//  Copyright © 2019 kien. All rights reserved.
//

import UIKit
import UserNotifications

class NotificationPermission {
    
    // MARK: - Static variables
    static func getAuthorizationStatus(completion: @escaping ((_ status: UNAuthorizationStatus) -> Void)) {
        let current = UNUserNotificationCenter.current()
        current.getNotificationSettings(completionHandler: { settings in
            completion(settings.authorizationStatus)
        })
    }
}
