//
//  APIUtilities.swift
//  DJCloud
//
//  Created by kien on 9/13/20.
//  Copyright © 2020 kienpt. All rights reserved.
//

import UIKit
import Alamofire

class APIUtilities {
    
    // MARK: - Singleton
    static let instance = APIUtilities()
    
    // MARK: - Variables
    private var reachabilityManager: NetworkReachabilityManager?
    
    // MARK: - Supporting functions
    static var hasInternet: Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
    
    func startDetectingInternetStatusChanged() {
        reachabilityManager = NetworkReachabilityManager()
        reachabilityManager?.startListening()
        reachabilityManager?.listener = { [weak self] _ in
            if let isNetworkReachable = self?.reachabilityManager?.isReachable, isNetworkReachable {
                // Internet is connected
            } else {
                // Internet is not connected
            }
        }
    }
}
