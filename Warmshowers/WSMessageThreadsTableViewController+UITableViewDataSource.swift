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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController?.sections else { return 0 }
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: RUID_MessageThread, for: indexPath) as! MessageThreadsTableViewCell
        
        guard let messageThread = self.fetchedResultsController?.object(at: indexPath) else {
            cell.participantsLabel.text = ""
            cell.dateLabel.text = ""
            cell.subjectLabel.text = ""
            cell.bodyPreviewLabel.text = "\n"
            cell.newDot.isHidden = true
            cell.threadID = nil
            return cell
        }
        
        configureCell(cell, withMessageThread: messageThread)
        return cell
    }
    
    func configureCell(_ cell: MessageThreadsTableViewCell, withMessageThread messageThread: WSMOMessageThread) {
        cell.participantsLabel.text = messageThread.getParticipantString(currentUserUID: currentUserUID)
        cell.dateLabel.text = textForMessageThreadDate(messageThread.last_updated)
        cell.subjectLabel.text = messageThread.subject ?? ""
        cell.bodyPreviewLabel.text = messageThread.lastestMessagePreview() ?? "\n"
        cell.newDot.isHidden = !messageThread.is_new
        cell.threadID = messageThread.thread_id
    }

}
