//
//  RegisterGuestAPI.swift
//  DJCloud
//
//  Created by kien on 11/23/20.
//  Copyright © 2020 kienpt. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class LoginUserGuestAPI: APIOperation<LoginUserGuestResponse> {

    init() {
        var param = Parameters()
        param["device_id"] = UIDevice.current.identifierForVendor?.uuidString
        super.init(request: APIRequest(name: "API0001 ▶︎ Sigin guest.",
                                       path: "auth/guest-sign-in",
                                       method: .post,
                                       parameters: .body(param)))
    }
}

struct LoginUserGuestResponse: APIResponseProtocol {

    // Variable from response data
    var guestAccount: String?
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
