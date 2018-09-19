//
//  Comment.swift
//  runit
//
//  Created by Jean-Paul Saysana on 12/11/2017.
//  Copyright © 2017 Denise NGUYEN. All rights reserved.
//

import Foundation
import SwiftyJSON
import TRON

struct Comment : JSONDecodable {
    let id : Int?
    let post_id : Int?
    let content : String?
    let picture : String?
    let created_at : String?
    let updated_at : String?
    let user_id : Int?
    let user_fullname : String?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case post_id = "post_id"
        case content = "content"
        case picture = "picture"
        case created_at = "created_at"
        case updated_at = "updated_at"
        case user_id = "user_id"
        case user_fullname = "user_fullname"
    }
    
    init(json: JSON) throws {
        var json = json["comment"]
        print("required init")
        print("JSON", "\(json)")
        
        self.id = json["id"].intValue
        self.post_id = json["post_id"].intValue
        self.content = json["content"].stringValue
        self.picture = json["picture"].stringValue
        self.created_at = json["created_at"].stringValue
        self.updated_at = json["updated_at"].stringValue
        self.user_id = json["user_id"].intValue
        self.user_fullname = json["user_fullname"].stringValue
    }

    
}
