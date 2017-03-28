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
        
        // Check for invalid states
        
        var title = NSLocalizedString("Could not send message.", tableName: "Compose", comment: "Title for the alert shown when a message could not be sent.")
        let button = NSLocalizedString("OK", comment: "OK button title")
        
        guard let body = body , body != "" else {
            let message = NSLocalizedString("Message has no content.", tableName: "Compose", comment: "Message for the alert shown when a message could not be sent due to it having no content.")
            alert.presentAlertFor(self, withTitle: title, button: button, message: message)
            return
        }
        
        guard let recipients = recipients else {
            let message = NSLocalizedString("Message has no recipients.", tableName: "Compose", comment: "Message for the alert shown when a message could not be sent due to it having no recipients.")
            alert.presentAlertFor(self, withTitle: title, button: button, message: message)
            return
        }
        
        guard let subject = subject , subject != "" else {
            let message = NSLocalizedString("Message has no subject.", tableName: "Compose", comment: "Message for the alert shown when a message could not be sent due to it having no subject.")
            alert.presentAlertFor(self, withTitle: title, button: button, message: message)
            return
        }
        
        if isReply {
            
            guard let threadID = threadID else {
                title = NSLocalizedString("Error", comment: "General error alert title")
                let message = NSLocalizedString("Sorry, an error occured while trying to send your message. Please reload the view and try again.", tableName: "Compose", comment: "Alert message when a reply to an unknown message is trying to be sent.")
                alert.presentAlertFor(self, withTitle: title, button: button, message: message)
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
        let spinnerLabel = NSLocalizedString("Sending message ...", tableName: "Compose", comment: "Message shown with the spinner while a message is being sent.")
        ProgressHUD.show(navigationController!.view, label: spinnerLabel)
    }
    
}
