//
//  WSLoginManager.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 26/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

class WSLoginManager : WSRequester, WSRequestDelegate {
    
    var username: String
    var password: String
    
    init(username: String, password: String) {
        self.username = username
        self.password = password
        super.init()
        requestDelegate = self
    }
    
    convenience override init() {
        let defaults = (UIApplication.sharedApplication().delegate as! AppDelegate).defaults
        let username = defaults.stringForKey(DEFAULTS_KEY_USERNAME)!
        let password = defaults.stringForKey(DEFAULTS_KEY_PASSWORD)!
        self.init(username: username, password: password)
    }
    
    func requestForDownload() -> NSURLRequest? {
        let service = WSRestfulService(type: .login)!
        let params = ["username" : username, "password" : password]
        let request = WSRequest.requestWithService(service, params: params, token: nil)
        return request
    }
    
    func doWithData(data: NSData) {
        
        guard let json = dataAsJSON() else {
            return
        }
        
        guard let sessionName = json.valueForKey("session_name") as? String,
            let sessid = json.valueForKey("sessid") as? String,
            let user = json.valueForKey("user")
        else {
            error = NSError(domain: "WSRequesterDomain", code: 20, userInfo: [NSLocalizedDescriptionKey: NSLocalizedString("Failed to parse login data", comment: "")])
            return
        }
        
        let defaults = (UIApplication.sharedApplication().delegate as! AppDelegate).defaults
        
        // Store the session data
        let sessionCookie = sessionName + "=" + sessid
        defaults.setValue(sessionCookie, forKey: DEFAULTS_KEY_SESSION_COOKIE)
        
        // Store the users uid
        if let uid = user["uid"] {
            defaults.setValue(uid, forKey: DEFAULTS_KEY_UID)
        }
        
        // Save the session data
        defaults.synchronize()
    }

}
