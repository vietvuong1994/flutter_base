//
//  GetListTopSingerAPI.swift
//  DJCloud
//
//  Created by kien on 10/30/20.
//  Copyright © 2020 kienpt. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class GetListTopArtistAPI: APIOperation<GetListTopArtistResponse> {

    init(size: Int? = nil) {
        var param = Parameters()
        if let limit = size {
            param["size"] = limit
        }
        super.init(request: APIRequest(name: "API0002 ▶︎ Get list top artist home.",
                                       path: "singer/top",
                                       method: .get,
                                       parameters: .body(param)))
    }
}

struct GetListTopArtistResponse: APIResponseProtocol {

    // Variable from response data
    var list: [Artist] = []
    
    init(json: JSON) {
        // Parse json data from server to local variables
        list = json["data"].arrayValue.map({ Artist(json: $0) })
    }
}
