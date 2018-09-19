//
//  User.swift
//  runit
//
//  Created by Denise NGUYEN on 05/11/2017.
//  Copyright © 2017 Denise NGUYEN. All rights reserved.
//

import Foundation
import SwiftyJSON
import TRON

struct User : JSONDecodable {
    
    //static let sharedInstance = User(json: [:])
    
    let id: String
    let email: String
    let firstname: String
    let lastname: String
    let address: String
    let phone: String
    let enable: Bool
    let authentication_token: String
    let description: String
    let weight: Double
    
    init(json: JSON) {
        var json = json["user"]
        print("JSON", "\(json)")
        self.id = json["id"].stringValue
        self.email = json["email"].stringValue
        self.firstname = json["firstname"].stringValue
        self.lastname = json["lastname"].stringValue
        self.address = json["address"].stringValue
        self.phone = json["phone"].stringValue
        self.enable = json["enable"].boolValue
        self.authentication_token = json["authentication_token"].stringValue
        self.description = json["description"].stringValue
        self.weight = json["weight"].doubleValue
    }
}
