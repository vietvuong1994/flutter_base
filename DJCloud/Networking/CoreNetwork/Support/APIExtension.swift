//
//  ErrorExtension.swift
//  DJCloud
//
//  Created by kien on 9/13/20.
//  Copyright © 2020 kienpt. All rights reserved.
//
import UIKit

extension Error {
    var errorCode: Int? {
        return (self as NSError).code
    }
    
    var urlCode: URLError.Code? {
        return (self as? URLError)?.code
    }
    
    var isUnknown: Bool {
        return urlCode  == .unknown
    }

    var isTimeout: Bool {
        return urlCode == .timedOut
    }
    
    var isHostNotFound: Bool {
        return urlCode == .cannotFindHost
    }
    
    var isHostConnectFailed: Bool {
        return urlCode == .cannotConnectToHost
    }
    
    var isNetworkConnectionLost: Bool {
        return urlCode == .networkConnectionLost
    }
    
    var isInternetOffline: Bool {
        return urlCode  == .notConnectedToInternet
    }
    
    var isBadServerResponse: Bool {
        return urlCode == .badServerResponse
    }
    
    
}
