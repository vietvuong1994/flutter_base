//
//  DispatcherProtocol.swift
//  DJCloud
//
//  Created by kien on 9/13/20.
//  Copyright © 2020 kienpt. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

public protocol APIDispatcherProtocol {
    // Execute the request
    func execute(request: APIRequest, completed: @escaping ((_ json: APIResponse) -> Void))
    func prepareBodyFor(request: APIRequest) -> URLRequestConvertible
    func prepareRawFor(request: APIRequest, rawText: String) -> URLRequest?
    func prepareHeadersForMultipartOrBinary(request: APIRequest) -> HTTPHeaders
    func cancel()
}
