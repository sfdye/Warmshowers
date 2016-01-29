//
//  MessageThreadsTableViewController+UITableViewDataSource.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 27/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

extension MessageThreadsTableViewController {
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if count == 0 {
            return 1
        } else {
            return count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if count == 0 {
            
            let cell = tableView.dequeueReusableCellWithIdentifier(PlaceholderCellID, forIndexPath: indexPath) as! PlaceholderTableViewCell
            cell.placeholderLabel.text = "No Messages"
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(MESSAGE_THREAD_CELL_ID, forIndexPath: indexPath) as! MessageThreadsTableViewCell
            
            let messageThread = CDWSMessageThread.messageThreadAtIndexPath(indexPath)
            cell.configureWithMessageThread(messageThread)
            return cell
        }
    }
    
}