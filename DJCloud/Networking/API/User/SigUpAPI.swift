//
//  SigUpAPI.swift
//  DJCloud
//
//  Created by kien on 11/24/20.
//  Copyright © 2020 kienpt. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class SigUpAPI: APIOperation<SigUpAPIResponse> {

    init(referer: String?, userName: String, email: String, password: String, confirmPass: String) {
        var param = Parameters()
        if let referer = referer {
            param["referer"] = referer
        }
        param["name"] = "kienpt"
        param["username"] = userName
        param["email"] = email
        param["password"] = password
        param["password_confirmation"] = confirmPass
        super.init(request: APIRequest(name: "API0003 ▶︎ Sigup.",
                                       path: "auth/signup",
                                       method: .post,
                                       parameters: .body(param),
                                       enviroment: .devEnv))
    }
}

struct SigUpAPIResponse: APIResponseProtocol {

    // Variable from response data
    var user: User?
    
    init(json: JSON) {
        // Parse json data from server to local variables
        SharedData.accessToken = json["data"]["access_token"].string
        user = User(json: json["data"]["user"])
        SharedData.userName = user?.userName
        SharedData.userNameDisplay = user?.name
        SharedData.avatarUser = user?.avatar
        AppDelegate.shared?.user = user
    }
}
