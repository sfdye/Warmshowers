//
//  MessageThreadsViewController+UITableViewDataSource.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 27/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit
import CoreData
import WarmshowersData

extension MessageThreadsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let sections = fetchedResultsController?.sections else { return 0 }
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController?.sections else { return 0 }
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageThreadCell", for: indexPath) as! MessageThreadsTableViewCell
        
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
    
    func configureCell(_ cell: MessageThreadsTableViewCell, withMessageThread messageThread: MOMessageThread) {
        cell.participantsLabel.text = messageThread.participantString(withCurrentUserUID: currentUserUID)
        cell.dateLabel.text = textForMessageThreadDate(messageThread.last_updated)
        cell.subjectLabel.text = messageThread.subject ?? ""
        cell.bodyPreviewLabel.text = messageThread.lastestMessagePreview() ?? "\n"
        cell.newDot.isHidden = !messageThread.is_new
        cell.threadID = messageThread.thread_id
    }

}
