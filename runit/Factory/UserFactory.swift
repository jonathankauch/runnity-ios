//
//  UserFactory.swift
//  runit
//
//  Created by Denise NGUYEN on 05/11/2017.
//  Copyright © 2017 Denise NGUYEN. All rights reserved.
//

import Foundation
import SwiftyJSON
import TRON

class UserRequestFactory
{
    static let tron = TRON(baseURL: RIAPI.BASE_URL)
    
    /// === Login ==
    class func login(parameters: [String:AnyObject]) -> APIRequest<User, Service.JSONError> {
        let request: APIRequest<User,Service.JSONError> = tron.request("login")
        request.method = .post
        request.parameters = parameters
        return request
    }
    
    class func logout() {
        print("Logged out.")
    }
    
    /// === CRUD ===
    class func create() -> APIRequest<User, Service.JSONError> {
        let request: APIRequest<User,Service.JSONError> = tron.request("users")
        request.method = .post
        return request
    }
    
    class func read(id: Int) -> APIRequest<User, Service.JSONError> {
        return tron.request("users/\(id)")
    }
    
    class func update(id: Int, parameters: [String:AnyObject]) -> APIRequest<User, Service.JSONError> {
        let request: APIRequest<User,Service.JSONError> = tron.request("users/\(id)")
        request.method = .put
        request.parameters = parameters
        return request
    }
    
    class func delete(id: Int) -> APIRequest<User,Service.JSONError> {
        let request: APIRequest<User,Service.JSONError> = tron.request("users/\(id)")
        request.method = .delete
        return request
    }
}
