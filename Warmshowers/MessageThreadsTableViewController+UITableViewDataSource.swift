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
        if messageThreads.count == 0 {
            return 1
        } else {
            return messageThreads.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if messageThreads.count == 0 {
            
            let cell = tableView.dequeueReusableCellWithIdentifier(PlaceholderCellID, forIndexPath: indexPath) as! PlaceholderTableViewCell
            cell.placeholderLabel.text = "No Messages"
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(MESSAGE_THREAD_CELL_ID, forIndexPath: indexPath) as! MessageThreadsTableViewCell
            
            let messageThread = messageThreads[indexPath.row]
            
            cell.participantsLabel.text = messageThread.getParticipantString(currentUserUID)
            cell.subjectLabel.text = messageThread.subject
            cell.setDate(messageThread.last_updated)
            
            if messageThread.is_new != 0 {
                cell.newDot.hidden = false
            } else {
                cell.newDot.hidden = true
            }
            
            if let latest = messageThread.lastestMessage() {
                // set the body preview
                if var preview = latest.body {
                    preview += "\n"
                    // TODO remove blank lines from the message body so the preview doens't display blanks
                    cell.bodyPreviewLabel.text = preview
                }
            } else {
                cell.bodyPreviewLabel.text = ""
            }
            
            return cell
        }
    }
    
}