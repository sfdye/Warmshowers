//
//  WSLoginEndPoint.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 27/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

class WSLoginEndPoint : WSAPIEndPointProtocol {
    
    var type: WSAPIEndPoint = .Login
    
    var httpMethod: HttpMethod = .Post
    
    var requiresAuthorization: Bool = false
    
#if TEST
    var mode: WSLoginEndPointTestingMode = .Success
#endif
    
    func url(withHostURL hostURL: URL, andParameters parameters: Any?) throws -> URL {
        return hostURL.appendingPathComponent("/services/rest/user/login")
    }
    
    func HTTPBodyParameters(withData data: Any?) throws -> [String: String] {
        guard data is WSLoginData else { throw WSAPIEndPointError.invalidOutboundData }
        return (data as! WSLoginData).asParameters
    }
    
    func request(_ request: WSAPIRequest, didRecieveResponseWithJSON json: Any) throws -> Any? {
        
        guard let sessionJSON = json as? [String: Any] else {
            throw WSAPIEndPointError.parsingError(endPoint: name, key: nil)
        }
        
        guard let userJSON = sessionJSON["user"] as? [String: Any] else {
            throw WSAPIEndPointError.parsingError(endPoint: name, key: "user")
        }
        
        do {
            let sessionName = try JSON.nonOptional(forKey: "session_name", fromJSON: sessionJSON, withType: String.self)
            let sessid = try JSON.nonOptional(forKey: "sessid", fromJSON: sessionJSON, withType: String.self)
            let sessionCookie = sessionName + "=" + sessid
            let token = try JSON.nonOptional(forKey: "token", fromJSON: sessionJSON, withType: String.self)
            let uid = try JSON.nonOptional(forKey: "uid", fromJSON: userJSON, withType: Int.self)
            WSSessionState.sharedSessionState.save(sessionCookie: sessionCookie, token: token, andUID: uid)
        }

        return json
    }
}
