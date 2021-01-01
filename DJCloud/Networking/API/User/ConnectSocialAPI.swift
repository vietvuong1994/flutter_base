//
//  ConnectSocialAPI.swift
//  DJCloud
//
//  Created by kien on 11/26/20.
//  Copyright © 2020 kienpt. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class ConnectSocialAPI: APIOperation<ConnectSocialResponse> {

    init(socialType: SocialType, token: String) {
        var param = Parameters()
        param["social_provider"] = socialType.rawValue
        param["social_token"] = token
        super.init(request: APIRequest(name: "API008 ▶︎ Connect social.",
                                       path: "auth/connect-social",
                                       method: .post,
                                       parameters: .body(param),
                                       enviroment: .devEnv))
    }
}

struct ConnectSocialResponse: APIResponseProtocol {

    // Variable from response data
    var user: User?
    
    init(json: JSON) {
        // Parse json data from server to local variables
        user = User(json: json["data"]["user"])
        AppDelegate.shared?.user = user
    }
}
