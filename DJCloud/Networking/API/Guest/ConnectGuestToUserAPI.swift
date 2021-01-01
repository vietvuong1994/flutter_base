//
//  ConnectGuestToUserAPI.swift
//  DJCloud
//
//  Created by kien on 11/25/20.
//  Copyright © 2020 kienpt. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class ConnectGuestToUserAPI: APIOperation<ConnectGuestToUserResponse> {

    init(userName: String, password: String, email: String) {
        var param = Parameters()
        param["username"] = userName
        param["email"] = email
        param["password"] = password
        super.init(request: APIRequest(name: "API006 ▶︎ Connect guest to account.",
                                       path: "auth/connect-normal-user",
                                       method: .post,
                                       parameters: .body(param),
                                       enviroment: .devEnv))
    }
}

struct ConnectGuestToUserResponse: APIResponseProtocol {

    // Variable from response data
    var user: User?
    
    init(json: JSON) {
        // Parse json data from server to local variables
        user = User(json: json["data"]["user"])
        SharedData.userName = user?.userName
        SharedData.userNameDisplay = user?.name
        SharedData.avatarUser = user?.avatar
        AppDelegate.shared?.user = user
    }
}
