//
//  WSCSRFTokenGetter.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 21/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

class WSCSRFTokenGetter : WSRequester, WSRequestDelegate {
    
    var token: String?
    
    override init(success: (() -> Void)?, failure: ((error: NSError) -> Void)?) {
        super.init(success: success, failure: failure)
        requestDelegate = self
    }
    
    func requestForDownload() throws -> NSURLRequest {
        do {
            let service = WSRestfulService.init(type: .Token)!
            let request = try WSRequest.requestWithService(service)
            return request
        }
    }
    
    func doWithData(data: NSData) {
        if let token = String.init(data: data, encoding: NSUTF8StringEncoding) {
            self.token = token
        } else {
            error = NSError(domain: "WSRequesterDomain", code: 10, userInfo: [NSLocalizedDescriptionKey: NSLocalizedString("Failed to decode token data.", comment: "")])
        }
    }
}