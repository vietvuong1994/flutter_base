//
//  PermissionUtils.swift
//  HopAmNhanh
//
//  Created by kien on 7/17/20.
//  Copyright © 2020 kienpt. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import Speech
import Photos

class Permission {
    
    static var recordStatus: AVAudioSession.RecordPermission {
        return AVAudioSession.sharedInstance().recordPermission
    }
    
    static var speechAuthor: SFSpeechRecognizerAuthorizationStatus {
        return SFSpeechRecognizer.authorizationStatus()
    }
    
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
    
    static func requestSpeechAuthorization(completion: @escaping ((_ authorized: Bool?) -> Void)) {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            OperationQueue.main.addOperation {
                switch authStatus
                {
                case .authorized :
                    completion(true)
                case .denied :
                    completion(false)
                case .restricted :
                    completion(false)
                case .notDetermined :
                    completion(nil)
                }
            }
        }
    }
    
    static var cameraAuthStatus: AVAuthorizationStatus {
        return AVCaptureDevice.authorizationStatus(for: .video)
    }
    
    static func requestCameraPermission(completion: @escaping ((_ authorized: Bool) -> Void)) {
        switch Permission.cameraAuthStatus {
        case .authorized:
            completion(true)
        case .denied:
            completion(false)
        default:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    completion(granted)
                }
            }
        }
    }
    
    static var photoAuthStatus: PHAuthorizationStatus {
        return PHPhotoLibrary.authorizationStatus()
    }
    
    static func requestPhotoPermission(completion: @escaping ((_ authorized: Bool) -> Void)) {
        switch Permission.photoAuthStatus {
        case .authorized:
            completion(true)
        case .denied:
            completion(false)
        default:
            PHPhotoLibrary.requestAuthorization { status in
                DispatchQueue.main.async {
                    completion(status == .authorized)
                }
            }
        }
    }
}
