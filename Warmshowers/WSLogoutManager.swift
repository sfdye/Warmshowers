//
//  WSLogoutManager.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 11/02/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

class WSLogoutManager : WSRequestWithCSRFToken, WSRequestDelegate {
    
    override init(success: (() -> Void)?, failure: ((error: NSError) -> Void)?) {
        super.init(success: success, failure: failure)
        requestDelegate = self
    }
    
    func requestForDownload() throws -> NSURLRequest {
        do {
            let service = WSRestfulService(type: .Logout)!
            let request = try WSRequest.requestWithService(service, token: token)
            return request
        }
    }
    
    func doWithData(data: NSData) {
        
        guard let json = dataAsJSON() where json.count == 1 else {
            setDataError()
            return
        }
        
        // Successful requests get a response with "1" in the body
        guard let success = json.objectAtIndex(0) as? Bool else {
            setDataError()
            return
        }
        
        if !success {
            print("User was not logged in")
        } else {
            print("User was logged in")
        }
    }

    func setDataError() {
        setError(401, description: "Failed to parse logout data")
    }
    
    // Convinience method to start the logout
    func logout() {
        tokenGetter.start()
    }
    
}