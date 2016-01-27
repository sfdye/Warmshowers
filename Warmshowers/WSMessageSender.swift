//
//  WSMessageSender.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 26/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

class WSMessageSender : WSRequestWithCSRFToken, WSRequestDelegate {
    
    var threadID: Int?
    var recipients: [CDWSUser]?
    var subject: String?
    var body: String?
    
    // Initialiser for replies
    init(threadID: Int, body: String) {
        super.init()
        requestDelegate = self
        self.threadID = threadID
        self.body = body
    }
    
    // Initialiser for new messages
    init(recipients: [CDWSUser], subject: String, body: String) {
        super.init()
        requestDelegate = self
        self.recipients = recipients
        self.subject = subject
        self.body = body
    }
    
    func requestForDownload() -> NSURLRequest? {
        // New message request
        if let threadID = threadID, let body = body {
            let service = WSRestfulService(type: .newMessage)!
            var params = [String: String]()
            params["thread_id"] = String(threadID)
            params["body"] = body
            let request = WSRequest.requestWithService(service, params: params, token: token)
            return request
        }
        
        // Reply request
        if let recipients = recipients, let subject = subject, let body = body {
            if let recipientsString = makeRecipientString(recipients) {
                let service = WSRestfulService(type: .replyToMessage)!
                var params = [String: String]()
                params["recipients"] = recipientsString
                params["subject"] = subject
                params["body"] = body
                let request = WSRequest.requestWithService(service, params: params, token: token)
                return request
            }
        }

        return nil
    }
    
    func doWithData(data: NSData) {
        
    }
    
    func makeRecipientString(recipients: [CDWSUser]) -> String? {
        
        var recipientString = ""
        for user in recipients {
            if let name = user.name {
                if recipientString == "" {
                    recipientString += name
                } else {
                    recipientString += "," + name
                }
            }
        }
        return recipientString
    }
    
}
