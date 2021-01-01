//
//  SigInAPI.swift
//  DJCloud
//
//  Created by kien on 11/25/20.
//  Copyright © 2020 kienpt. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class SigInAPI: APIOperation<SigInResponse> {

    init(userName: String, password: String) {
        var param = Parameters()
        param["email_or_username"] = userName
        param["password"] = password
        param["remember_me"] = true
        super.init(request: APIRequest(name: "API0004 ▶︎ Sigin.",
                                       path: "auth/login",
                                       method: .post,
                                       parameters: .body(param)))
    }
}

struct SigInResponse: APIResponseProtocol {

    // Variable from response data
    var user: User?
    
    init(json: JSON) {
        // Parse json data from server to local variables
        user = User(json: json["data"]["user"])
        SharedData.accessToken = json["data"]["access_token"].string
        SharedData.userName = user?.userName
        SharedData.userNameDisplay = user?.name
        SharedData.avatarUser = user?.avatar
        AppDelegate.shared?.user = user
    }
}
