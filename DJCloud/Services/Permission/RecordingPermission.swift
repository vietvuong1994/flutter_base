//
//  RecordingPermission.swift
//  iOS Structure MVC
//
//  Created by kien on 2/19/19.
//  Copyright © 2019 kien. All rights reserved.
//

import UIKit
import AVFoundation

class RecordingPermission {
    
    // MARK: - Static variables
    static var recordStatus: AVAudioSession.RecordPermission {
        return AVAudioSession.sharedInstance().recordPermission
    }
    
    static var isNotDetermined: Bool {
        return RecordingPermission.recordStatus == .undetermined
    }
    
    static var isAuthorized: Bool {
        return RecordingPermission.recordStatus == .granted
    }
    
    static var isDenied: Bool {
        return RecordingPermission.recordStatus == .denied
    }
    
    // MARK: - Static functions
    static func requestRecordPermission(completion: @escaping ((_ authorized: Bool) -> Void)) {
        switch recordStatus {
        case .granted:
            completion(true)
        case .denied:
            completion(false)
        default:
            AVAudioSession.sharedInstance().requestRecordPermission { granted in
                DispatchQueue.main.async {
                    completion(granted)
                }
            }
        }
    }
}
