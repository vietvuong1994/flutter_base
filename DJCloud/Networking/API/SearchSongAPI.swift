//
//  SearchSongAPI.swift
//  HopAmNhanh
//
//  Created by kien on 8/17/20.
//  Copyright © 2020 kienpt. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class SearchSongAPI: APIOperation<SearchSongResponse> {

    init(keyWord: String, offset: Int? = nil, limit: Int? = nil) {
        var param = Parameters()
        param["search"] = keyWord
        if let offset = offset {
            param["offset"] = offset
        }
        if let limit = limit {
            param["limit"] = limit
        }
        super.init(request: APIRequest(name: "API0009 ▶︎ Search song by name.",
                                       path: "song/search",
                                       method: .get,
                                       parameters: .body(param)))
    }
}

struct SearchSongResponse: APIResponseProtocol {

    // Variable from response data
    var list: [PlayableItem] = []
    
    init(json: JSON) {
        // Parse json data from server to local variables
        list = json["data"].arrayValue.map({ PlayableItem(json: $0) })
    }
}
