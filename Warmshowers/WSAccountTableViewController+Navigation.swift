//
//  WSAccountTableViewController+Navigation.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 10/07/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

extension WSAccountTableViewController {
    
    func doneButtonPressed() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        guard let user = user else { return false }
        switch identifier {
        case ToFeedbackSegueID:
            return user.feedback?.count ?? 0 > 0
        case ToSendNewMessageSegueID:
            assertionFailure("Broken")
            return false //(info != nil && uid != nil && recipient != nil)
        case ToProvideFeeedbackSegueID:
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
            
        case ToFeedbackSegueID:
            
            let feedbackVC = segue.destinationViewController as! WSFeedbackTableViewController
            feedbackVC.feedback = user.feedback
            
        case ToSendNewMessageSegueID:
            assertionFailure("Broken")
//            let navVC = segue.destinationViewController as! UINavigationController
//            let composeMessageVC = navVC.viewControllers.first as! WSComposeMessageViewController
//            if let info = info, let uid = uid {
//                // Save the user to the store and pass the user object to the compose message view controller
//                do {
//                    try store.addParticipantWithJSON(info)
//                    recipient = try store.participantWithID(uid)
//                    composeMessageVC.initialiseAsNewMessageToUser([recipient!])
//                } catch {
//                    print("Failed to get user for compose message view")
//                }
//            }
            
        case ToProvideFeeedbackSegueID:
            assertionFailure("Broken")
//            let navVC = segue.destinationViewController as! UINavigationController
//            let createFeedbackVC = navVC.viewControllers.first as! WSCreateFeedbackTableViewController
//            createFeedbackVC.configureForSendingFeedbackForUserWithUserName(info?.valueForKey("name") as? String)
            
        default:
            break
        }
    }
    
}