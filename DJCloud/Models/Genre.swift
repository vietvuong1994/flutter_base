//
//  Genre.swift
//  veezee
//
//  Created by Vahid Amiri Motlagh on 2/11/18.
//  Copyright © 2018 veezee. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Genre: Codable {
	var _id : [String:String]?;
	var id : String?;
	var title : String?;
	var image : String?;
    var slug: String?
	
	enum CodingKeys: String, CodingKey {
		case _id
		case id
		case title
		case image
	}
	
	init() {
		
	}
	
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self);
		
		id = try container.decode(._id, transformer: MongodbObjectIdCodableTransformer());
		title = try container.decode(String?.self, forKey: .title);
		image = (try? container.decode(String?.self, forKey: .image)) ?? nil;
	}
	
	func encode(to encoder: Encoder) throws {
		var container =  encoder.container(keyedBy: CodingKeys.self);
		
		try container.encode(id ?? "", forKey: ._id, transformer: MongodbObjectIdCodableTransformer());
		try container.encode(self.title, forKey: .title);
		try container.encode(self.image, forKey: .image);
	}
    
    init(json: JSON) {
        id = json["id"].int?.string()
        title = json["name"].string
        if let imageStr = json["gallery"].string {
            image = Constants.API_BASE_URL + imageStr
        }
        slug = json["slug"].string
    }
}
