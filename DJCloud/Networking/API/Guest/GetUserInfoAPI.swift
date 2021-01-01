//
//  GetGuestUserInfoAPI.swift
//  DJCloud
//
//  Created by kien on 11/23/20.
//  Copyright © 2020 kienpt. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class GetUserInfoAPI: APIOperation<GetUserInfoResponse> {

    init() {
        super.init(request: APIRequest(name: "API0002 ▶︎ Get guest info.",
                                       path: "auth/user",
                                       method: .get,
                                       parameters: .body([:]),
                                       enviroment: .devEnv))
    }
}

struct GetUserInfoResponse: APIResponseProtocol {

    // Variable from response data
    var user: User?
    
    init(json: JSON) {
        // Parse json data from server to local variables
        user = User(json: json["data"])
        SharedData.userName = user?.userName
        SharedData.userNameDisplay = user?.name
        SharedData.avatarUser = user?.avatar
        AppDelegate.shared?.user = user
    }
    
}
