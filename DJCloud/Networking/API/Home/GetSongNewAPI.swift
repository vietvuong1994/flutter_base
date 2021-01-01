//
//  GetSongNewAPI.swift
//  DJCloud
//
//  Created by kien on 10/30/20.
//  Copyright © 2020 kienpt. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class GetSongNewAPI: APIOperation<GetSongNewResponse> {

    init(size: Int? = nil) {
        var param = Parameters()
        if let limit = size {
            param["size"] = limit
        }
        super.init(request: APIRequest(name: "API0001 ▶︎ Get list song new home.",
                                       path: "song/newest",
                                       method: .get,
                                       parameters: .body(param)))
    }
}

struct GetSongNewResponse: APIResponseProtocol {

    // Variable from response data
    var list: [PlayableItem] = []
    
    init(json: JSON) {
        // Parse json data from server to local variables
        list = json["data"]["data"].arrayValue.map({ PlayableItem(json: $0) })
    }
}
