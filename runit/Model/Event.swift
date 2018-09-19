//
//  Event.swift
//  runit
//
//  Created by Denise NGUYEN on 06/11/2017.
//  Copyright © 2017 Denise NGUYEN. All rights reserved.
//

import Foundation
import SwiftyJSON
import TRON

struct Event: JSONDecodable {
    let id: Int
    let name: String
    let description: String
    let start_date: NSDate
    let end_date: NSDate
    let city: String
    let `private`: Bool
    let distance: Int
    let user_id: Int

    init(json: JSON) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        self.id = json["id"].intValue
        self.name = json["name"].stringValue
        self.description = json["description"].stringValue
        self.start_date = dateFormatter.date(from: json["start_date"].stringValue)! as NSDate
        self.end_date = dateFormatter.date(from: json["end_date"].stringValue)! as NSDate
        self.city = json["city"].stringValue
        self.`private` = json["private"].boolValue
        self.distance = json["distance"].intValue
        self.user_id = json["user_id"].intValue
    }
    
    // Constructor
    init(id: Int = 0, name: String = "", description: String = "", start_date: NSDate = NSDate(), end_date: NSDate = NSDate(), city: String = "", `private`: Bool = false, distance: Int = 0, user_id: Int = 0) {
        self.id = id
        self.name = name
        self.description = description
        self.start_date = start_date
        self.end_date = end_date
        self.city = city
        self.`private` = `private`
        self.distance = distance
        self.user_id = user_id
    }
}


