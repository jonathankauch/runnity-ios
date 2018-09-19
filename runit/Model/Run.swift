//
//  Run.swift
//  runit
//
//  Created by Denise NGUYEN on 05/11/2017.
//  Copyright © 2017 Denise NGUYEN. All rights reserved.
//

import Foundation
import SwiftyJSON
import TRON

struct Coordinate: JSONDecodable {

    var longitude: Double
    var latitude: Double
    var timestamp: Int
    
    var dict:[String:Any] {
        get {
            return ["longitude": longitude,
                    "latitude": latitude,
                    "timestamp": timestamp] as [String : Any]
        }
    }

    init(json: JSON) {
            self.longitude = json["longitude"].doubleValue
            self.latitude = json["latitude"].doubleValue
        
            //let dateFormatter = DateFormatter()
            //dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            self.timestamp = json["timestamp"].intValue
    }
    
    init(longitude: Double,
         latitude: Double,
         timestamp: Int) {
        self.longitude = longitude
        self.latitude = latitude
        self.timestamp = timestamp
    }
}

struct Run: JSONDecodable {
    var id: Int
    let started_at: String
    let user_token: String
    let user_email: String
    let max_speed: Double
    let is_spot: Bool
    let total_distance: Int
    let total_time: Int
    var coordinates: Array<Coordinate>
    
    init(json: JSON) {
        self.id = json["id"].intValue
        self.started_at = json["started_at"].stringValue
        self.user_token = json["user_token"].stringValue
        self.user_email = json["user_email"].stringValue
        self.max_speed = json["max_speed"].doubleValue
        self.is_spot = json["is_spot"].boolValue
        self.total_distance = json["total_distance"].intValue
        self.total_time = json["total_time"].intValue
        self.coordinates = [Coordinate]()
        for (_, v) in json["coordinates"] {
            self.coordinates.append(Coordinate(json: v))
        }
    }
    
    init(id: Int, started_at: String, user_token: String, user_email: String, max_speed: Double, is_spot: Bool, total_distance: Int, total_time: Int, coordinates: Array<Coordinate>) {
        self.id = id
        self.started_at = started_at
        self.user_token = user_token
        self.user_email = user_email
        self.max_speed = max_speed
        self.is_spot = is_spot
        self.total_distance = total_distance
        self.total_time = total_time
        self.coordinates = coordinates
        
    }
}

