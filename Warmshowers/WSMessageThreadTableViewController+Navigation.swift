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
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == SID_ReplyToMessageThread {
            return threadID != nil
        }
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SID_ReplyToMessageThread {
            let navVC = segue.destination as! UINavigationController
            let composeMessageVC = navVC.viewControllers.first as! WSComposeMessageViewController
            composeMessageVC.configureAsReply(threadID)
        }
    }
    
}
