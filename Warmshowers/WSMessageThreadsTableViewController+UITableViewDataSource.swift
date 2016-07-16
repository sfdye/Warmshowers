//
//  WSMessageThreadsTableViewController+UITableViewDataSource.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 27/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit
import CoreData

let RUID_MessageThread = "MessageThreadCell"
let RUID_NoMessageThreadsCell = "NoMessages"

extension WSMessageThreadsTableViewController {
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController.sections else { return 0 }
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier(RUID_MessageThread, forIndexPath: indexPath) as! MessageThreadsTableViewCell
        
        guard let messageThread = self.fetchedResultsController.objectAtIndexPath(indexPath) as? CDWSMessageThread else {
            cell.participantsLabel.text = ""
            cell.dateLabel.text = ""
            cell.subjectLabel.text = ""
            cell.bodyPreviewLabel.text = "\n"
            cell.newDot.hidden = true
            cell.threadID = nil
            return cell
        }
        
        configureCell(&cell, withMessageThread: messageThread)    
        return cell
    }
    
    func configureCell(inout cell: MessageThreadsTableViewCell, withMessageThread messageThread: CDWSMessageThread) {
        cell.participantsLabel.text = messageThread.getParticipantString(currentUserUID)
        cell.dateLabel.text = textForMessageThreadDate(messageThread.last_updated)
        cell.subjectLabel.text = messageThread.subject ?? ""
        cell.bodyPreviewLabel.text = messageThread.lastestMessagePreview() ?? "\n"
        cell.newDot.hidden = !(messageThread.is_new?.boolValue ?? false)
        cell.threadID = messageThread.thread_id?.integerValue
    }

}