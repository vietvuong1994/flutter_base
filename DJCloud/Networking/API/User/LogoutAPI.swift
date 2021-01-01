//
//  LogoutAPI.swift
//  DJCloud
//
//  Created by kien on 11/25/20.
//  Copyright © 2020 kienpt. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class LogoutAPI: APIOperation<LogoutResponse> {

    init() {
        super.init(request: APIRequest(name: "API0006 ▶︎ Logout.",
                                       path: "auth/logout",
                                       method: .get,
                                       parameters: .body([:]),
                                       enviroment: .devEnv))
    }
}

struct LogoutResponse: APIResponseProtocol {

    // Variable from response data
    var user: User?
    
    init(json: JSON) {
        // Parse json data from server to local variables
        SharedData.accessToken = nil
        SharedData.userNameDisplay = nil
        SharedData.avatarUser = nil
        if AppDelegate.shared?.user?.isGuest == false {
            SharedData.userName = nil
        }
        AppDelegate.shared?.user = nil
    }
}
