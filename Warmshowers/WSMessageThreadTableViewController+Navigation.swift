//
//  WSMessageThreadTableViewController+Navigation.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 13/07/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

let SID_ReplyToMessageThread = "ToReplyToMessage"

extension WSMessageThreadTableViewController {
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if identifier == SID_ReplyToMessageThread {
            if let _ = try? store.messageThreadWithID(threadID!) {
                return true
            }
        }
        return false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SID_ReplyToMessageThread {
            let navVC = segue.destinationViewController as! UINavigationController
            let composeMessageVC = navVC.viewControllers.first as! WSComposeMessageViewController
            composeMessageVC.configureAsReply(threadID)
        }
    }
    
}
