//
//  UserEndPoint.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 9/05/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

class UserEndPoint: APIEndPointProtocol {
    
    var type: APIEndPoint = .user
    
    func url(withHostURL hostURL: URL, andParameters parameters: Any?) throws -> URL {
        
        guard let uidString = parameters as? String else {
            throw APIEndPointError.invalidPathParameters(endPoint: name, errorDescription: "The user end point must receieve a valid user UID in the path parameters.")
        }
        
        return hostURL.appendingPathComponent("/services/rest/user/\(uidString)")
    }
    
     func request(_ request: APIRequest, didRecieveResponseWithJSON json: Any, parser: JSONParser) throws -> Any? {
        
        guard let userInfo = User(json: json) else {
            throw APIEndPointError.parsingError(endPoint: name, key: nil)
        }
        
        return userInfo
    }
    
}
