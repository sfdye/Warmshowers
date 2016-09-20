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
        
        guard let json = json as? [String: Any] else {
            throw WSAPIEndPointError.parsingError(endPoint: name, key: nil)
        }
        
        guard let sessionName = json["session_name"] as? String else {
            throw WSAPIEndPointError.parsingError(endPoint: name, key: "session_name")
        }
        
        guard let sessid = json["sessid"] as? String else {
            throw WSAPIEndPointError.parsingError(endPoint: name, key: "sessid")
        }
        
        guard let token = json["token"] as? String else {
            throw WSAPIEndPointError.parsingError(endPoint: name, key: "token")
        }
        
        guard let user = json["user"] as? [String: Any] else {
            throw WSAPIEndPointError.parsingError(endPoint: name, key: "user")
        }
        
        guard let uid = user["uid"] as? Int else {
            throw WSAPIEndPointError.parsingError(endPoint: name, key: "uid")
        }
        
        // Store the session data
        let sessionCookie = sessionName + "=" + sessid
        WSSessionState.sharedSessionState.saveSessionData(sessionCookie, token: token, uid: uid)
        
        return json
    }
}
