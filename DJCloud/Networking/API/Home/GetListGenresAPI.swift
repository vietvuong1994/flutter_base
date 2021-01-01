//
//  GetListGenresAPI.swift
//  DJCloud
//
//  Created by kien on 10/30/20.
//  Copyright © 2020 kienpt. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class GetListGenresAPI: APIOperation<GetListGenresResponse> {

    init(size: Int? = nil) {
        var param = Parameters()
        if let limit = size {
            param["size"] = limit
        }
        super.init(request: APIRequest(name: "API007 ▶︎ Get list genres.",
                                       path: "song-genres",
                                       method: .get,
                                       parameters: .body(param)))
    }
}

struct GetListGenresResponse: APIResponseProtocol {

    // Variable from response data
    var list: [Genre] = []
    
    init(json: JSON) {
        // Parse json data from server to local variables
        list = json["data"]["data"].arrayValue.map({ Genre(json: $0) })
    }
}
