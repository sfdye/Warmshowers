//
//  WSLoginManager.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 26/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

class WSLoginManager : WSRequestWithCSRFToken, WSRequestDelegate {
    
    override init(success: (() -> Void)?, failure: ((error: NSError) -> Void)?) {
        super.init(success: success, failure: failure)
        requestDelegate = self
    }
    
    // Note that reqeusts are built with the username and password saved to the NSUserdefaults and keychain with WSLoginData. Hence these varialble must be saved first before a valid request can be made.
    //
    func requestForDownload() throws -> NSURLRequest {
        do {
            let (username, password) = try WSLoginData.getCredentials()
            let service = WSRestfulService(type: .Login)!
            let params = ["username" : username, "password" : password]
            let request = try WSRequest.requestWithService(service, params: params, token: token)
            return request
        }
    }
    
    func doWithData(data: NSData) {
        
        guard let json = dataAsJSON() else {
            setDataError()
            return
        }
            
        guard let sessionName = json.valueForKey("session_name") as? String,
            let sessid = json.valueForKey("sessid") as? String,
            let user = json.valueForKey("user")
            else {
                setDataError()
                return
        }
        
        guard let uid = user.valueForKey("uid")?.integerValue else {
            setDataError()
            return
        }
        
        // Store the session data
        let sessionCookie = sessionName + "=" + sessid
        WSLoginData.saveSessionData(sessionCookie, uid: uid)
    }
    
    func setDataError() {
        setError(401, description: "Failed to parse login data")
    }
    
    // Convinience method to start the login process
    //
    func login() {
        tokenGetter.start()
    }

}
