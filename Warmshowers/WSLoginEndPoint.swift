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
    
    func urlWithHostURL(hostURL: NSURL, andParameters parameters: AnyObject?) throws -> NSURL {
        return hostURL.URLByAppendingPathComponent("/services/rest/user/login")
    }
    
    func HTTPBodyParametersWithData(data: AnyObject?) throws -> [String: String] {
        guard data is WSLoginData else { throw WSAPIEndPointError.InvalidOutboundData }
        return (data as! WSLoginData).asParameters
    }
    
    func request(request: WSAPIRequest, didRecieveResponseWithJSON json: AnyObject) throws -> AnyObject? {
        
        guard let sessionName = json.valueForKey("session_name") as? String else {
            throw WSAPIEndPointError.ParsingError(endPoint: name, key: "session_name")
        }
        
        guard let sessid = json.valueForKey("sessid") as? String else {
            throw WSAPIEndPointError.ParsingError(endPoint: name, key: "sessid")
        }
        
        guard let token = json.valueForKey("token") as? String else {
            throw WSAPIEndPointError.ParsingError(endPoint: name, key: "token")
        }
        
        guard let user = json.valueForKey("user") else {
            throw WSAPIEndPointError.ParsingError(endPoint: name, key: "user")
        }
        
        guard let uid = user.valueForKey("uid")?.integerValue else {
            throw WSAPIEndPointError.ParsingError(endPoint: name, key: "uid")
        }
        
        // Store the session data
        let sessionCookie = sessionName + "=" + sessid
        WSSessionState.sharedSessionState.saveSessionData(sessionCookie, token: token, uid: uid)
        
        return json
    }
}