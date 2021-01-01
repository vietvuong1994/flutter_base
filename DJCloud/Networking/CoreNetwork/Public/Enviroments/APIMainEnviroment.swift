//
//  MainEnviroment.swift
//  DJCloud
//
//  Created by kien on 9/13/20.
//  Copyright © 2020 kienpt. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class APIMainEnviroment {
    
    var baseUrl: String
    
    var headers: HTTPHeaders

    var encoding: ParameterEncoding

    var timeout: TimeInterval
    
    func parseApiErrorJson(_ json: JSON, statusCode: Int?) -> APIError? {
        // Try to parse input json to error class according to your error json format
        // Example:
        guard let errorId = json["error_id"].int else { return nil }
        let errorMessage = json["error_message"].string
        return APIError.api(statusCode: statusCode,
                            apiCode: errorId,
                            message: errorMessage)
    }
    
    class var devEnv: APIMainEnviroment {
        return APIMainEnviroment(baseUrl: APIConfiguration.baseUrl,
                             headers: APIConfiguration.defaultHeaders,
                             encoding: APIConfiguration.encoding,
                             timeout: APIConfiguration.timeout)
    }
    
    class var putEnv: APIMainEnviroment {
        return APIMainEnviroment(baseUrl: APIConfiguration.baseUrl,
                             headers: APIConfiguration.putHeaders,
                             encoding: APIConfiguration.encoding,
                             timeout: APIConfiguration.timeout)
    }
    
    class var googleEnv: APIMainEnviroment {
        return APIMainEnviroment(baseUrl: APIConfiguration.baseGoogleUrl,
                                 headers: [:],
                                 encoding: URLEncoding.default,
                                 timeout: APIConfiguration.timeout)
    }
    
    // MARK: - Init
    init(baseUrl: String, headers: HTTPHeaders, encoding: ParameterEncoding, timeout: TimeInterval) {
        self.baseUrl = baseUrl
        self.headers = headers
        self.encoding = encoding
        self.timeout = timeout
    }
}
