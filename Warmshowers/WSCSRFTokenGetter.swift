//
//  WSCSRFTokenGetter.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 21/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

class WSCSRFTokenGetter : WSRequester, WSRequestDelegate {
    
    var token: String?
    
    override init() {
        super.init()
        requestDelegate = self
    }
    
    func requestForDownload() -> NSURLRequest? {
        let service = WSRestfulService.init(type: .token)!
        let request = WSRequest.requestWithService(service)
        return request
    }
    
    func doWithData(data: NSData) {
        if let token = String.init(data: data, encoding: NSUTF8StringEncoding) {
            self.token = token
        } else {
            error = NSError(domain: "WSRequesterDomain", code: 10, userInfo: [NSLocalizedDescriptionKey: NSLocalizedString("Failed to decode token data.", comment: "")])
        }
    }
    
}