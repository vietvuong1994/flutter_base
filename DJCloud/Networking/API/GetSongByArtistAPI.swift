//
//  GetSongByArtistAPI.swift
//  DJCloud
//
//  Created by kien on 12/10/20.
//  Copyright © 2020 kienpt. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class GetSongByArtistAPI: APIOperation<GetSongByArtistResponse> {

    init(slug: String, size: Int? = nil) {
        var param = Parameters()
        if let limit = size {
            param["size"] = limit
        }
        super.init(request: APIRequest(name: "API0002 ▶︎ Get list top artist home.",
                                       path: "singer/\(slug)/songs",
                                       method: .get,
                                       parameters: .body(param)))
    }
}

struct GetSongByArtistResponse: APIResponseProtocol {

    // Variable from response data
    var list: [PlayableItem] = []
    
    init(json: JSON) {
        // Parse json data from server to local variables
        list = json["data"].arrayValue.map({ PlayableItem(json: $0) })
    }
}
