//
//  MessageThreadViewController+Navigation.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 13/07/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

let SID_MessagesToReply = "MessagesToReply"
let SID_MessagesToUserProfile = "MessagesToUserProfile"

extension MessageThreadViewController {
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        switch identifier {
        case SID_MessagesToReply:
            return threadID != nil
        case SID_MessagesToUserProfile:
            guard let uid = sender as? Int, uid > 0 else { return false }
            return true
        default:
            return false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        switch identifier {
        case SID_MessagesToReply:
            let navVC = segue.destination as! UINavigationController
            let composeMessageVC = navVC.viewControllers.first as! ComposeMessageViewController
            composeMessageVC.configureAsReply(threadID)
            composeMessageVC.delegate = self
        case SID_MessagesToUserProfile:
            guard let uid = sender as? Int, uid > 0 else { return }
            let userProfileTVC = segue.destination as! UserProfileTableViewController
            userProfileTVC.uid = uid
            break
        default:
            break
        }
    }
    
}
