//
//  WSMessageThreadsTableViewController+Navigation.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 12/07/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

extension WSMessageThreadsTableViewController {
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if identifier == MessageSegueID {
            if let cell = sender as? MessageThreadsTableViewCell {
                if cell.threadID != nil {
                    return true
                }
            }
        }
        return false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == MessageSegueID {
            // Assign the message thread data to the destination view controller
            let messageThreadVC = segue.destinationViewController as! WSMessageThreadTableViewController
            messageThreadVC.threadID = (sender as? MessageThreadsTableViewCell)?.threadID
        }
    }
    
}