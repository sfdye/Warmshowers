//
//  WSMessageSender.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 26/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

enum WSMessageSenderError : ErrorType {
    case C
}

class WSMessageSender : WSRequestWithCSRFToken, WSRequestDelegate {
    
    var threadID: Int?
    var recipients: [CDWSUser]?
    var subject: String?
    var body: String?
    
    // Initialiser for replies
    init(threadID: Int, body: String, success: (() -> Void)?, failure: ((error: NSError) -> Void)?) {
        super.init(success: success, failure: failure)
        requestDelegate = self
        self.threadID = threadID
        self.body = body
    }
    
    // Initialiser for new messages
    init(recipients: [CDWSUser], subject: String, body: String, success: (() -> Void)?, failure: ((error: NSError) -> Void)?) {
        super.init(success: success, failure: failure)
        requestDelegate = self
        self.recipients = recipients
        self.subject = subject
        self.body = body
    }
    
    func requestForDownload() throws -> NSURLRequest {
        
        var service: WSRestfulService?
        var params = [String: String]()
        
        // New message request
        if let threadID = threadID, let body = body {
            service = WSRestfulService(type: .newMessage)!
            params["thread_id"] = String(threadID)
            params["body"] = body
        }
        
        // Reply request
        if let recipients = recipients, let subject = subject, let body = body {
            if let recipientsString = makeRecipientString(recipients) {
                service = WSRestfulService(type: .replyToMessage)!
                params["recipients"] = recipientsString
                params["subject"] = subject
                params["body"] = body
            }
        }
        
        if let service = service {
            do {
                let request = try WSRequest.requestWithService(service, params: params, token: token)
                return request
            }
        } else {
            throw WSRequesterError.CouldNotCreateRequest
        }
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
    
    // Starts the message sending process
    //
    func send() {
        tokenGetter.start()
    }
    
}
