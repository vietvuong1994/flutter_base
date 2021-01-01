//
//  User.swift
//  veezee
//
//  Created by Vahid Amiri Motlagh on 3/23/18.
//  Copyright © 2018 veezee. All rights reserved.
//

import Foundation
import SwiftyJSON

struct User: Codable {
    var id: Int?
    var userName: String?
	var name : String?
	var email: String?
	var password: String?
	var access: UserAccess?
	var token: String?
	var expiresIn: Date?
    var avatar: String?
    var social: [SocialType] = []
    var isGuest: Bool = true
    var imgAvatar: UIImage?
	
	enum CodingKeys: String, CodingKey {
        case id
		case name
		case email
		case password
		case access
		case token
		case expiresIn
	}
	
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		id = (try? container.decode(Int?.self, forKey: .id)) ?? nil
		name = (try? container.decode(String?.self, forKey: .name)) ?? nil
		email = (try? container.decode(String?.self, forKey: .email)) ?? nil
		password = (try? container.decode(String?.self, forKey: .password)) ?? nil
		access = (try? container.decode(UserAccess?.self, forKey: .access)) ?? nil
		token = (try? container.decode(String?.self, forKey: .token)) ?? nil
		expiresIn = (try? container.decode(Date?.self, forKey: .expiresIn)) ?? nil
	}
	
	func encode(to encoder: Encoder) throws {
		var container =  encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
		try container.encode(self.name, forKey: .name)
		try container.encode(self.email, forKey: .email)
		try container.encode(self.password, forKey: .password)
		try container.encode(self.access, forKey: .access)
		try container.encode(self.token, forKey: .token)
		try container.encode(self.expiresIn, forKey: .expiresIn)
	}
    
    init(json: JSON) {
        id = json["id"].int
        userName = json["username"].string
        name = json["name"].string
        email = json["email"].string
        password = json["password"].string
        avatar = json["avatar_url"].string
        isGuest = json["is_guest"].bool ?? true
        json["social_list"].arrayValue.forEach({ (js) in
            if let value = js.string, let type = SocialType(rawValue: value) {
                social.append(type)
            }
        })
    }
}
