//
//  WSComposeMessageViewController+Actions.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 13/07/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

extension WSComposeMessageViewController {
    
    @IBAction func sendButtonPressed(sender: AnyObject?) {
        
        self.view.endEditing(true)
        
        guard let body = body where body != "" else {
            alert.presentAlertFor(self, withTitle: "Could not send message.", button: "OK", message: "Message has no content.")
            return
        }
        
        guard let recipients = recipients else {
            alert.presentAlertFor(self, withTitle: "Could not send message.", button: "OK", message: "Message has no recipients.")
            return
        }
        
        guard let subject = subject where subject != "" else {
            alert.presentAlertFor(self, withTitle: "Could not send message.", button: "OK", message: "Message has no subject.")
            return
        }
        
        if isReply {
            
            guard let threadID = threadID else {
                alert.presentAlertFor(self, withTitle: "Error", button: "OK", message: "Sorry, an error occured while trying to send your message. Please reload the view and try again.")
                return
            }
            
            let reply = WSReplyMessageData(threadID: threadID, body: body)
            api.contactEndPoint(.ReplyToMessage, withPathParameters: nil, andData: reply, thenNotify: self)
            
        } else {
            
            let recipientsString = recipientStringForRecipients(recipients)
            let message = WSNewMessageData(recipientsString: recipientsString, subject: subject, body: body)
            api.contactEndPoint(.NewMessage, withPathParameters: nil, andData: message, thenNotify: self)
        }
        
        // Show the spinner
        WSProgressHUD.show(navigationController!.view, label: "Sending message ...")
    }
    
}