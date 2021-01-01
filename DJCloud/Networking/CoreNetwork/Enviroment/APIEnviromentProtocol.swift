//
//  APIEnviromentProtocol.swift
//  DJCloud
//
//  Created by kien on 9/13/20.
//  Copyright © 2020 kienpt. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

public protocol APIEnviromentProtocol {
    // MARK: - Variable interfaces
    var baseUrl: String { get }
    var headers: HTTPHeaders { get }
    var encoding: ParameterEncoding { get }
    var timeout: TimeInterval { get }
    
    // MARK: - Function interfaces
    func parseApiErrorJson(_ json: JSON, statusCode: Int?) -> APIError?
}
