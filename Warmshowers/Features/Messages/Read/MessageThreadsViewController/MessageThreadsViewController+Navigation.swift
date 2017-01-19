//
//  MessageThreadsViewController+Navigation.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 12/07/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

let SID_ThreadsToMessages = "ThreadsToMessages"
let SID_ThreadsToReply = "ThreadsToReply"

extension MessageThreadsViewController {
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        switch identifier {
        case SID_ThreadsToMessages:
            // Only perform the segue if the thread is in the store.
            return (sender as? MessageThreadsTableViewCell)?.threadID != nil
        case SID_ThreadsToReply:
            return (sender as? MessageThreadViewController)?.threadID != nil
        default:
            return false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        switch identifier {
        case SID_ThreadsToMessages:
            if
                let cell = sender as? MessageThreadsTableViewCell,
                let messageThreadVC = segue.destination as? MessageThreadViewController
            {
                // Assign the message thread data to the destination view controller
                messageThreadVC.threadID = cell.threadID
                messageThreadVC.delegate = self
            }
        case SID_ThreadsToReply:
            if
                let threadID = (sender as? MessageThreadViewController)?.threadID,
                let navVC = segue.destination as? UINavigationController,
                let composeMessageVC = navVC.viewControllers.first as? ComposeMessageViewController
            {
                composeMessageVC.configureAsReply(threadID)
                composeMessageVC.delegate = self
            }
        default:
            return
        }
        
    }
    
}
