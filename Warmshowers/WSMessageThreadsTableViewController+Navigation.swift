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
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        // Only perform the segue if the thread is in the store.
        if let cell = sender as? MessageThreadsTableViewCell , identifier == SID_ToMessageThread {
            return cell.threadID != nil
        }
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SID_ToMessageThread && sender is MessageThreadsTableViewCell {
            // Assign the message thread data to the destination view controller
            let messageThreadVC = segue.destination as! WSMessageThreadTableViewController
            messageThreadVC.threadID = (sender as? MessageThreadsTableViewCell)?.threadID
        }
    }
    
}
