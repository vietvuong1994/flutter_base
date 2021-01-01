//
//  ErrorExtension.swift
//  DJCloud
//
//  Created by kien on 9/13/20.
//  Copyright © 2020 kienpt. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

public enum APIError {
    case api(statusCode: Int?, apiCode: Int?, message: String?)
    case request(statusCode: Int?, error: Error?)
    
    var apiCode: Int? {
        switch self {
        case .api(_, let apiCode, _):
            return apiCode
        default:
            return nil
        }
    }
    
    var statusCode: Int? {
        switch self {
        case .api(let statusCode, _, _):
            return statusCode
        case .request(let statusCode, _):
            return statusCode
        }
    }
    
    var message: String? {
        switch self {
        case .api(_, _, let message):
            return message
        case .request(_, let error):
            guard let error = error else {
                return "Lỗi không xác định"
            }
            if error.isInternetOffline || error.isNetworkConnectionLost || error.isHostConnectFailed {
                return "Không có kết nối Internet"
            } else if error.isTimeout {
                return "Quá thời gian kết nối tới máy chủ"
            } else if error.isBadServerResponse {
                return "Không có dữ liệu từ máy chủ"
            } else {
                return "Không thể kết nối đến máy chủ"
            }
        }
    }
    
    // Create an unknown api error
    static var unknown: APIError {
        return APIError.request(statusCode: nil, error: nil)
    }
}
