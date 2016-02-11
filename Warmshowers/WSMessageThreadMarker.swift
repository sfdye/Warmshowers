//
//  WSMessageThreadMarker.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 11/02/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation
import CoreData

class WSMessageThreadMarker : WSRequestWithCSRFToken, WSRequestDelegate {
    
    var threadID: Int!
    var unread = false
    var store: WSMessageStore!
    
    init(threadID: Int, store: WSMessageStore, success: (() -> Void)?, failure: ((error: NSError) -> Void)?) {
        super.init(success: success, failure: failure)
        requestDelegate = self
        self.threadID = threadID
        self.store = store
    }
    
    func requestForDownload() throws -> NSURLRequest {
        do {
            let service = WSRestfulService(type: .MarkMessage)!
            let params: [String: String] = ["thread_id": String(threadID), "status" : String(Int(unread))]
            let request = try WSRequest.requestWithService(service, params: params, token: token)
            return request
        }
    }
    
    func doWithData(data: NSData) {
        
        guard let json = dataAsJSON() else {
            return
        }
        
        // Successful requests get a response with "1" in the body
        if json.count == 1 {
            if let success = json.objectAtIndex(0) as? Bool {
                if success {
                    // On success update the local model
                    do {
                        try self.store.markMessageThread(self.threadID, unread: self.unread)
                    } catch {
                        // This is not an important error
                    }

                }
            }
        }
        
    }
    
    // Conviniences method to initiate the message thread marking request
    //
    
    func markAsRead() {
        mark(false)
    }
    
    func markAsUnread() {
        mark(true)
    }
    
    func mark(unread: Bool) {
        self.unread = unread
        self.tokenGetter.start()
    }
}
