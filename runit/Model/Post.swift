//
//  Post.swift
//  runit
//
//  Created by Jean-Paul Saysana on 12/11/2017.
//  Copyright © 2017 Denise NGUYEN. All rights reserved.
//

import Foundation
import SwiftyJSON
import TRON

struct PostData {
    let content : String
    let user_name : String
    let id : Int
}

struct UserPost : JSONDecodable {
    
    let user_id : Int
    let full_name : String?

    init(json: JSON) {
        print(json)
        var json = json["posts"]
        print("required init")
        print("JSON", "\(json)")
        
        self.user_id = json["user_id"].intValue
        self.full_name = json["full_name"].stringValue
    }
}

struct Post : JSONDecodable {

    let id : Int
    let owner : String
    let content : String?
    let comments : String?
    let picture : String?
    let created_at : String?
    let updated_at : String?
    let user_id : Int?
    let _private : String?
    let like : Int?
    let event_id : String?
    let group_id : String?
    let user : UserPost
    
    init(json: JSON) {
        print(json)
        var json = json["posts"]
        print("required init")
        print("JSON", "\(json)")

        self.id = json["id"].intValue
        self._private = json["private"].stringValue
        self.like = json["like"].intValue
        self.comments = json["comments"].stringValue
        self.owner = json["owner"].stringValue
        self.picture = json["picture"].stringValue
        self.created_at = json["created_at"].stringValue
        self.user_id = json["user_id"].intValue
        self.group_id = json["group_id"].stringValue
        self.updated_at = json["updated_at"].stringValue
        self.event_id = json["event_id"].stringValue
        self.user = UserPost(json: json)
        
        //UserPost(user_id: user_id, full_name: full_name)
        //user = UserPost(user_id: user_id, full_name: full_name)
        self.content = json["content"].stringValue
    }
}
