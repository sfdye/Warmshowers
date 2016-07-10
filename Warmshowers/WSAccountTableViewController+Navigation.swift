//
//  WSAccountTableViewController+Navigation.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 10/07/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

extension WSAccountTableViewController {
    
    func doneButtonPressed() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        switch identifier {
        case ToFeedbackSegueID:
            return feedback.count > 0
        case ToSendNewMessageSegueID:
            return (info != nil && uid != nil && recipient != nil)
        case ToProvideFeeedbackSegueID:
            return info?.valueForKey("name") as? String != nil ? true : false
        default:
            return false
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == ToFeedbackSegueID {
            let feedbackVC = segue.destinationViewController as! WSFeedbackTableViewController
            feedbackVC.feedback = feedback
        }
        if segue.identifier == ToSendNewMessageSegueID {
            let navVC = segue.destinationViewController as! UINavigationController
            let composeMessageVC = navVC.viewControllers.first as! WSComposeMessageViewController
            if let info = info, let uid = uid {
                // Save the user to the store and pass the user object to the compose message view controller
                do {
                    try store.addParticipantWithJSON(info)
                    recipient = try store.participantWithID(uid)
                    composeMessageVC.initialiseAsNewMessageToUser([recipient!])
                } catch {
                    print("Failed to get user for compose message view")
                }
            }
        }
        if segue.identifier == ToProvideFeeedbackSegueID {
            let navVC = segue.destinationViewController as! UINavigationController
            let createFeedbackVC = navVC.viewControllers.first as! WSCreateFeedbackTableViewController
            createFeedbackVC.configureForSendingFeedbackForUserWithUserName(info?.valueForKey("name") as? String)
        }
    }
    
}