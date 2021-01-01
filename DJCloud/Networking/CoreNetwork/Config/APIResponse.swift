//
//  APIResponse.swift
//  DJCloud
//
//  Created by kien on 9/13/20.
//  Copyright © 2020 kienpt. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

// Define response data types for each request
public enum APIResponse {
    case success(_: JSON)
    case error(_: APIError)
    
    init(_ response: DataResponse<Any>, fromRequest request: APIRequest) {
        // Get status code
        let statusCode = response.response?.statusCode
        
        // Check if the request error exists
        if let error = response.result.error {
            self = .error(APIError.request(statusCode: statusCode, error: error))
            return
        }
        
        // Check if response has data or not
        guard let jsonData = response.result.value else {
            self = .error(APIError.request(statusCode: statusCode, error: response.error))
            return
        }
        
        // Try to parse api error if possible
        let json: JSON = JSON(jsonData)
        if let error = request.enviroment.parseApiErrorJson(json, statusCode: statusCode) {
            self = .error(error)
            return
        }
        
        // Get data successfully
        self = .success(json)
    }
}

// Model repsonse protocol based on JSON data (View Controller's layers are able to view this protocol as response data)
public protocol APIResponseProtocol {
    // Set json as input variable
    init(json: JSON)
}
