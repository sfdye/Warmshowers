//
//  ComposeMessageViewController+Actions.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 13/07/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation
import WarmshowersData

extension ComposeMessageViewController {
    
    @IBAction func sendButtonPressed(_ sender: AnyObject?) {
        
        self.view.endEditing(true)
        
        guard let body = body , body != "" else {
            alert.presentAlertFor(self, withTitle: "Could not send message.", button: "OK", message: "Message has no content.")
            return
        }
        
        guard let recipients = recipients else {
            alert.presentAlertFor(self, withTitle: "Could not send message.", button: "OK", message: "Message has no recipients.")
            return
        }
        
        guard let subject = subject , subject != "" else {
            alert.presentAlertFor(self, withTitle: "Could not send message.", button: "OK", message: "Message has no subject.")
            return
        }
        
        if isReply {
            
            guard let threadID = threadID else {
                alert.presentAlertFor(self, withTitle: "Error", button: "OK", message: "Sorry, an error occured while trying to send your message. Please reload the view and try again.")
                return
            }
            
            let reply = ReplyMessageData(threadID: threadID, body: body)
            api.contact(endPoint: .replyToMessage, withMethod: .post, andPathParameters: nil, andData: reply, thenNotify: self, ignoreCache: false)
            
        } else {
            
            let recipientsString = recipientString(forRecipientUsernames: recipients)
            let message = NewMessageData(recipientsString: recipientsString, subject: subject, body: body)
            api.contact(endPoint: .newMessage, withMethod: .post, andPathParameters: nil, andData: message, thenNotify: self, ignoreCache: false)
        }
        
        // Show the spinner
        ProgressHUD.show(navigationController!.view, label: "Sending message ...")
    }
    
}
