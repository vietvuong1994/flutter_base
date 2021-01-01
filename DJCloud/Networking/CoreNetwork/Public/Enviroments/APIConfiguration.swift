//
//  APIConfiguration.swift
//  DJCloud
//
//  Created by kien on 9/13/20.
//  Copyright © 2020 kienpt. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class APIConfiguration {
    
    // Base url of web service
    static var baseUrl: String {
        return "http://upload.djcloud.vn/api/v1"
    }
    
    static var baseGoogleUrl: String {
        return "https://maps.googleapis.com/maps/api"
    }
    
    static var defaultHeaders: HTTPHeaders {
        if let token = SharedData.accessToken {
            let sendToken = "Bearer " + token
            return ["Authorization" : sendToken]
        }
        return [:]
    }
    
    static var putHeaders: HTTPHeaders {
        if let token = SharedData.accessToken {
            let sendToken = "Bearer " + token
            return ["Authorization" : sendToken, "Content-Type": "application/x-www-form-urlencoded"]
        }
        return [:]
    }
    
    static let encoding: ParameterEncoding = URLEncoding.default
    
    static let timeout: TimeInterval = 30
}

