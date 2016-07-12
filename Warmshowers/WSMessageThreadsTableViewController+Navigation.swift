//
//  WSMessageThreadsTableViewController+Navigation.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 12/07/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

let SID_ToMessageThread = "ToMessageThread"

extension WSMessageThreadsTableViewController {
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        // Only perform the segue if the thread is in the store.
        if let cell = sender as? MessageThreadsTableViewCell where identifier == SID_ToMessageThread {
            return cell.threadID != nil
        }
        return false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SID_ToMessageThread && sender is MessageThreadsTableViewCell {
            // Assign the message thread data to the destination view controller
            let messageThreadVC = segue.destinationViewController as! WSMessageThreadTableViewController
            messageThreadVC.threadID = (sender as? MessageThreadsTableViewCell)?.threadID
        }
    }
    
}