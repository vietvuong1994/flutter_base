//
//  GetLinkSongFileAPI.swift
//  DJCloud
//
//  Created by kien on 12/2/20.
//  Copyright © 2020 kienpt. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class GetLinkSongFileAPI: APIOperation<GetLinkSongFileResponse> {

    init(slug: String) {
        super.init(request: APIRequest(name: "API0009 ▶︎ Get link song file.",
                                       path: "song/media/\(slug)",
                                       method: .get,
                                       parameters: .body([:])))
    }
}

struct GetLinkSongFileResponse: APIResponseProtocol {

    // Variable from response data
    var url: URL?
    
    init(json: JSON) {
        // Parse json data from server to local variables
        if let urlStr = json["data"]["url"].string {
            url = URL(string: Constants.API_BASE_URL + urlStr)
        }
    }
}
