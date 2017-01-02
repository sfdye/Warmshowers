//
//  MessageThreadTableViewController+Navigation.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 13/07/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

let SID_ReplyToMessageThread = "ToReplyToMessage"
let SID_MessageThreadToUserProfile = "MessageThreadToUserProfile"

extension MessageThreadTableViewController {
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        switch identifier {
        case SID_ReplyToMessageThread:
            return threadID != nil
        case SID_MessageThreadToUserProfile:
            guard let uid = sender as? Int, uid > 0 else { return false }
            return true
        default:
            return false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        switch identifier {
        case SID_ReplyToMessageThread:
            let navVC = segue.destination as! UINavigationController
            let composeMessageVC = navVC.viewControllers.first as! ComposeMessageViewController
            composeMessageVC.configureAsReply(threadID)
        case SID_MessageThreadToUserProfile:
            guard let uid = sender as? Int, uid > 0 else { return }
            let userProfileTVC = segue.destination as! UserProfileTableViewController
            userProfileTVC.uid = uid
            break
        default:
            break
        }
    }
    
}
