//
//  PostFactory.swift
//  runit
//
//  Created by Jean-Paul Saysana on 12/11/2017.
//  Copyright © 2017 Denise NGUYEN. All rights reserved.
//

import Foundation
import SwiftyJSON
import TRON

class PostRequestFactory
{
    static let tron = TRON(baseURL: RIAPI.BASE_URL)

    /// === POST CRUD ===
    class func create(parameters: [String:AnyObject]) -> APIRequest<Post, Service.JSONError> {
        let request: APIRequest<Post,Service.JSONError> = tron.request("posts")
        request.headers = ["X-User-Email": UserSession.sharedInstance.email,
                           "X-User-Token": UserSession.sharedInstance.token]
        request.parameters = parameters
        request.method = .post
        return request
    }

    
    class func readAll() -> APIRequest<Post, Service.JSONError> {
        let request: APIRequest<Post,Service.JSONError> = tron.request("posts")
        request.method = .get
        request.headers = [
            "X-User-Email": UserSession.sharedInstance.email,
            "X-User-Token": UserSession.sharedInstance.token
        ]
        return request
    }

    class func read(id: Int) -> APIRequest<Post, Service.JSONError> {
        
        let request: APIRequest<Post,Service.JSONError> = tron.request("posts")
        request.headers = ["X-User-Email": UserSession.sharedInstance.email,
                           "X-User-Token": UserSession.sharedInstance.token]
        return request
    }

    /*
    class func update(id: Int, parameters: [String:AnyObject]) -> APIRequest<Post, Service.JSONError> {
        let request: APIRequest<Post,Service.JSONError> = tron.request("posts/\(id)")
        request.method = .put
        request.parameters = parameters
        return request
    }
    
    class func delete(id: Int) -> APIRequest<Posts,Service.JSONError> {
        let request: APIRequest<Posts,Service.JSONError> = tron.request("posts/\(id)")
        request.method = .delete
        return request
    }
    */
}
