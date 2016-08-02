//
//  WSAccountTableViewController+Navigation.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 10/07/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

let SID_ToFeedback = "ToFeedback"
let SID_ToSendNewMessage = "ToSendNewMessage"
let SID_ToProvideFeeedback = "ToProvideFeedback"

extension WSAccountTableViewController {
    
    func doneButtonPressed() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        guard let user = user else { return false }
        switch identifier {
        case SID_ToFeedback:
            return user.feedback?.count ?? 0 > 0
        case SID_ToSendNewMessage:
            return recipient != nil
        case SID_ToProvideFeeedback:
            return user.name != ""
        default:
            return false
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard
            let identifier = segue.identifier,
            let user = user
            else { return }
        
        switch identifier {
            
        case SID_ToFeedback:
            
            let feedbackVC = segue.destinationViewController as! WSFeedbackTableViewController
            feedbackVC.feedback = user.feedback
            
        case SID_ToSendNewMessage:

            let navVC = segue.destinationViewController as! UINavigationController
            let composeMessageVC = navVC.viewControllers.first as! WSComposeMessageViewController
            
            // Save the user to the store and pass the user object to the compose message view controller
            let json = ["uid": user.uid, "fullname": user.fullname, "name": user.name]
            
            if let recipient = try? store.newOrExisting(WSMOUser.self, withJSON: json, context: store.managedObjectContext) {
                composeMessageVC.configureAsNewMessageToUsers([recipient])
                try! store.managedObjectContext.save()
            }
            
        case SID_ToProvideFeeedback:
            
            let navVC = segue.destinationViewController as! UINavigationController
            let createFeedbackVC = navVC.viewControllers.first as! WSCreateFeedbackTableViewController
            createFeedbackVC.configureForSendingFeedbackForUserWithUserName(user.name)
            
        default:
            break
        }
    }
    
}