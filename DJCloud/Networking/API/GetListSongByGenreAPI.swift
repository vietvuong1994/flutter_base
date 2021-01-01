//
//  GetListSongByGenreAPI.swift
//  DJCloud
//
//  Created by kien on 10/30/20.
//  Copyright © 2020 kienpt. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class GetListSongByGenreAPI: APIOperation<GetListSongByGenreResponse> {

    init(slug: String, offset: Int? = nil, limit: Int? = nil) {
        var param = Parameters()
        if let offset = offset {
            param["offset"] = offset
        }
        if let limit = limit {
            param["limit"] = limit
        }
        super.init(request: APIRequest(name: "API0009 ▶︎ Get list song by genre.",
                                       path: "song/genre/\(slug)",
                                       method: .get,
                                       parameters: .body(param)))
    }
}

struct GetListSongByGenreResponse: APIResponseProtocol {

    // Variable from response data
    var list: [PlayableItem] = []
    
    init(json: JSON) {
        // Parse json data from server to local variables
        list = json["data"]["data"].arrayValue.map({ PlayableItem(json: $0) })
    }
}
