//
//  UserSession.swift
//  runit
//
//  Created by Denise NGUYEN on 05/11/2017.
//  Copyright © 2017 Denise NGUYEN. All rights reserved.
//

import Foundation

class UserSession {
    static let sharedInstance = UserSession()
    var email: String
    var token: String
    var id: String
    var firstname: String
    var lastname: String
    var phone: String
    var address: String
    var description: String
    var weight: Double
    
    var news_id: Int
    var news_content: String
    var news_user: String
    var news_user_id: String
    var news_date: String
    
    var comment_id: Int
    var comment_content: String
    var comment_date: String
    var comment_user: String
    
    var friend_id: Int
    var friend_req_id: Int
    var friend_req_name: String
    
    var group_id : Int
    var group_user_id : Int
    var group_private_status: Bool
    var group_is_register: Bool
    var group_name: String
    var group_picture: String
    var group_description: String
    var group_avatar_file_name: String
    var group_avatar_content_type: String
    
    var share_run_id: Int

    private init(){
        self.email = ""
        self.token = ""
        self.id = ""
        self.firstname = ""
        self.lastname = ""
        self.address = ""
        self.phone = ""
        self.description = ""
        self.weight = 0

        news_id = 0
        news_content = ""
        news_date = ""
        news_user = ""
        news_user_id = ""

        friend_id = 0
        friend_req_id = 0
        friend_req_name = ""

        comment_user = ""
        comment_content = ""
        comment_date = ""
        comment_id = 0

        self.group_id = 0
        self.group_user_id = 0
        self.group_private_status = false
        self.group_is_register = false
        self.group_name = ""
        self.group_picture = ""
        self.group_description = ""
        self.group_avatar_file_name = ""
        self.group_avatar_content_type = ""
        
        self.share_run_id = 0
        
    }
    
    public static func sharedInstanceWith(email:String, token:String, id: String, firstname: String, lastname: String, address: String, phone: String, description: String, weight: Double) -> UserSession {
        let instance = UserSession.sharedInstance
        instance.email = email
        instance.token = token
        instance.id = id
        instance.firstname = firstname
        instance.lastname = lastname
        instance.address = address
        instance.phone = phone
        instance.description = description
        instance.weight = weight
        
        return instance
    }
    
    func destroy() {
        self.email = ""
        self.token = ""
        self.id = ""
        self.firstname = ""
        self.lastname = ""
        self.address = ""
        self.phone = ""
        self.description = ""
        self.weight = 0.0
        print("Destroyed user session")
    }
}

