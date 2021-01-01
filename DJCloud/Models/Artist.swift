//
//  Artist.swift
//  veezee
//
//  Created by Vahid Amiri Motlagh on 2/11/18.
//  Copyright © 2018 veezee. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Artist: Codable {
	var _id : [String:String]?;
	var id : String?;
	var name : String?;
    var thumbImage: String?
    var followersCount: Int = 0
    var slug: String?
	
	enum CodingKeys: String, CodingKey {
		case _id
		case id
		case name
	}
	
	init() {
		
	}
	
    init(json: JSON) {
        id = json["id"].int?.string()
        name = json["name"].string
        if let image = json["gallery"].string {
            thumbImage = Constants.API_BASE_URL + image
        }
        followersCount = json["followers_count"].int ?? 0
        slug = json["slug"].string
    }
    
//	init(from decoder: Decoder) throws {
//		let container = try decoder.container(keyedBy: CodingKeys.self);
//
//		id = try container.decode(._id, transformer: MongodbObjectIdCodableTransformer());
//		name = try container.decode(String?.self, forKey: .name);
//	}
//
//	func encode(to encoder: Encoder) throws {
//		var container =  encoder.container(keyedBy: CodingKeys.self);
//
//		try container.encode(id ?? "", forKey: ._id, transformer: MongodbObjectIdCodableTransformer());
//		try container.encode(self.name, forKey: .name);
//	}
}
