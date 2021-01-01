//
//  LoginWithSocialAPI.swift
//  DJCloud
//
//  Created by kien on 11/27/20.
//  Copyright © 2020 kienpt. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class LoginWithSocialAPI: APIOperation<LoginWithSocialResponse> {

    init(socialType: SocialType, token: String) {
        var param = Parameters()
        param["social_provider"] = socialType.rawValue
        param["social_token"] = token
        super.init(request: APIRequest(name: "API0004 ▶︎ Login with social.",
                                       path: "auth/social-sign-in",
                                       method: .post,
                                       parameters: .body(param)))
    }
}

struct LoginWithSocialResponse: APIResponseProtocol {

    // Variable from response data
    var user: User?
    
    init(json: JSON) {
        // Parse json data from server to local variables
        user = User(json: json["data"]["user"])
        SharedData.accessToken = json["data"]["access_token"].string
        AppDelegate.shared?.user = user
    }
}
