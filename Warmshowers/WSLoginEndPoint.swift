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
    
    var type: WSAPIEndPoint { return .login }
    
    var path: String { return "/services/rest/user/login" }
    
    var method: HttpMethod { return .Post }
#if TEST
    var mode: WSLoginEndPointTestingMode = .Success
#endif
    func request(_ request: WSAPIRequest, didRecievedResponseWithJSON json: AnyObject) throws -> AnyObject? {
        
        guard let sessionName = json.value(forKey: "session_name") as? String else {
            throw WSAPIEndPointError.parsingError(endPoint: path, key: "session_name")
        }
        
        guard let sessid = json.value(forKey: "sessid") as? String else {
            throw WSAPIEndPointError.parsingError(endPoint: path, key: "sessid")
        }
        
        guard let token = json.value(forKey: "token") as? String else {
            throw WSAPIEndPointError.parsingError(endPoint: path, key: "token")
        }
        
        guard let user = json.value(forKey: "user") else {
            throw WSAPIEndPointError.parsingError(endPoint: path, key: "user")
        }
        
        guard let uid = user.value(forKey: "uid")?.intValue else {
            throw WSAPIEndPointError.parsingError(endPoint: path, key: "uid")
        }
        
        // Store the session data
        let sessionCookie = sessionName + "=" + sessid
        WSSessionState.sharedSessionState.saveSessionData(sessionCookie, token: token, uid: uid)
        
        return json
    }
}
