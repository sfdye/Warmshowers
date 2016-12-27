//
//  UserProfileTableViewController+Navigation.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 10/07/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit
import WarmshowersData

let SID_ToFeedback = "ToFeedback"
let SID_ToSendNewMessage = "ToSendNewMessage"
let SID_ToProvideFeeedback = "ToProvideFeedback"

extension UserProfileTableViewController {
    
    func doneButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            let identifier = segue.identifier,
            let user = user
            else { return }
        
        switch identifier {
            
        case SID_ToFeedback:
            
            let feedbackVC = segue.destination as! FeedbackTableViewController
            feedbackVC.feedback = user.feedback
            
        case SID_ToSendNewMessage:

            let navVC = segue.destination as! UINavigationController
            let composeMessageVC = navVC.viewControllers.first as! ComposeMessageViewController
            
            // Save the user to the store and pass the user object to the compose message view controller
            let json = ["uid": user.uid, "fullname": user.fullname, "name": user.name] as [String : Any]
            assertionFailure("refactor")
//            if let recipient: MOUser = try? store.newOrExisting(ofClass: MOUser.self, withJSON: json, context: store.managedObjectContext) {
//                composeMessageVC.configureAsNewMessageToUsers([recipient])
//                try! store.managedObjectContext.save()
//            }
            
        case SID_ToProvideFeeedback:
            
            let navVC = segue.destination as! UINavigationController
            let createFeedbackVC = navVC.viewControllers.first as! CreateFeedbackTableViewController
            createFeedbackVC.configureForSendingFeedbackForUserWithUserName(user.name)
            
        default:
            break
        }
    }
    
}
