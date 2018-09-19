//
//  RunFactory.swift
//  runit
//
//  Created by Denise NGUYEN on 05/11/2017.
//  Copyright © 2017 Denise NGUYEN. All rights reserved.
//

import Foundation
import SwiftyJSON
import TRON
import Alamofire

class RunRequestFactory
{
    static let tron = TRON(baseURL: RIAPI.BASE_URL)
    static let headers = [
        "X-User-Email": UserSession.sharedInstance.email,
        "X-User-Token": UserSession.sharedInstance.token]
    
    /// === CRUD ===
    class func create(parameters:[String: Any]) -> APIRequest<Run, Service.JSONError> {
        let request: APIRequest<Run, Service.JSONError> = tron.request("runs")
        request.method = .post
        request.headers = headers
        request.parameters = parameters
        request.parameterEncoding = JSONEncoding.default
        return request
    }
    
    class func read(id: Int) -> APIRequest<Run, Service.JSONError> {
        return tron.request("runs/\(id)")
    }
    
    class func update(id: Int, parameters: [String:AnyObject]) -> APIRequest<Run, Service.JSONError> {
        let request: APIRequest<Run, Service.JSONError> = tron.request("runs/\(id)")
        request.method = .put
        request.parameters = parameters
        return request
    }
    
    class func delete(id: Int) -> APIRequest<Run, Service.JSONError> {
        let request: APIRequest<Run, Service.JSONError> = tron.request("runs/\(id)")
        request.method = .delete
        return request
    }
}

