//
//  GetHistorySearchAPI.swift
//  DJCloud
//
//  Created by kien on 10/30/20.
//  Copyright © 2020 kienpt. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class GetHistorySearchAPI: APIOperation<GetHistorySearchResponse> {

    init(offset: Int? = nil, limit: Int? = nil) {
        var param = Parameters()
        if let offset = offset {
            param["offset"] = offset
        }
        if let limit = limit {
            param["limit"] = limit
        }
        super.init(request: APIRequest(name: "API0010 ▶︎ Search history.",
                                       path: "search-history",
                                       method: .get,
                                       parameters: .body(param)))
    }
}

struct GetHistorySearchResponse: APIResponseProtocol {

    // Variable from response data
    var list: [String] = []
    
    init(json: JSON) {
        // Parse json data from server to local variables
        json["data"].arrayValue.forEach { (js) in
            if let key = js["search"].string {
                list.append(key)
            }
        }
    }
}
