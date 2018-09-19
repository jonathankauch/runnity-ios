//
//  Service.swift
//  runit
//
//  Created by Denise NGUYEN on 05/11/2017.
//  Copyright © 2017 Denise NGUYEN. All rights reserved.
//

import Foundation

import Foundation
import TRON
import SwiftyJSON

struct Service {
    static let tron = TRON(baseURL: RIAPI.BASE_URL)
    static let sharedInstance = Service()

    struct JSONError: JSONDecodable {
        let code: Int
        let message: String
        
        init(json: JSON) throws {
            print("JSON ERROR", json)
            self.code = json["code"].intValue
            self.message = json["message"].stringValue
        }
    }
}
