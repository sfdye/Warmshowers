//
//  WSLoginEndPoint.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 27/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

class WSLoginEndPoint : WSAPIEndPointProtocol {
    
    static let sharedEndPoint = WSLoginEndPoint()
    
    var type: WSAPIEndPoint { return .Login }
    
    var path: String { return "/services/rest/user/login" }
    
    var method: HttpMethod { return .Post }
    
    func request(request: WSAPIRequest, didRecievedResponseWithJSON json: AnyObject) throws -> AnyObject? {
        
        guard let sessionName = json.valueForKey("session_name") as? String else {
            throw WSAPIEndPointError.ParsingError(endPoint: path, key: "session_name")
        }
        
        guard let sessid = json.valueForKey("sessid") as? String else {
            throw WSAPIEndPointError.ParsingError(endPoint: path, key: "sessid")
        }
        
        guard let token = json.valueForKey("token") as? String else {
            throw WSAPIEndPointError.ParsingError(endPoint: path, key: "token")
        }
        
        guard let user = json.valueForKey("user") else {
            throw WSAPIEndPointError.ParsingError(endPoint: path, key: "user")
        }
        
        guard let uid = user.valueForKey("uid")?.integerValue else {
            throw WSAPIEndPointError.ParsingError(endPoint: path, key: "uid")
        }
        
        // Store the session data
        let sessionCookie = sessionName + "=" + sessid
        WSSessionState.sharedSessionState.saveSessionData(sessionCookie, token: token, uid: uid)
        
        return json
    }
}