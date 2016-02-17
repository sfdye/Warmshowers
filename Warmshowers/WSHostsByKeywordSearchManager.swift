//
//  WSHostsByKeywordSearchManager.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 16/02/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

class WSHostsByKeywordSearchManager : WSRequestWithCSRFToken, WSRequestDelegate {
    
    var limit: Int! = 50
    var hostList = [WSUserLocation]()
    var keyword: String?
    var offset = 0
    
    override init(success: (() -> Void)?, failure: ((error: NSError) -> Void)?) {
        super.init(success: success, failure: failure)
        requestDelegate = self
    }
    
    func requestForDownload() throws -> NSURLRequest {
        do {
            let service = WSRestfulService(type: .SearchByKeyword)!
            var params = [String: String]()
            params["keyword"] = keyword ?? " "
            params["offset"] = String(offset)
            params["limit"] = String(limit)
            let request = try WSRequest.requestWithService(service, params: params, token: token)
            return request
        }
    }
    
    func doWithData(data: NSData) {
        
        guard let json = dataAsJSON() as? [String: AnyObject] else {
            return
        }

        hostList = [WSUserLocation]()
        if let accounts = json["accounts"] as? NSDictionary {
            for (_, account) in accounts {
                if let user = WSUserLocation(json: account) {
                    hostList.append(user)
                }
            }
        }
    }
    
    // Starts the message sending process
    //
    func update(keyword: String, offset: Int = 0) {
        self.keyword = keyword
        self.offset = offset
        tokenGetter.start()
    }
}
