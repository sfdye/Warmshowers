//
//  WSMessageThreadTableViewController+UITableViewDataSource.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 27/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit
import CoreData


let RUI_MessageFromSelf = "MessageFromSelf"
let RUI_MessageFromUser = "MessageFromUser"

extension WSMessageThreadTableViewController {
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController.sections else { return 0 }
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        guard let message = self.fetchedResultsController.objectAtIndexPath(indexPath) as? CDWSMessage else {
            let cell = tableView.dequeueReusableCellWithIdentifier(RUI_MessageFromSelf, forIndexPath: indexPath) as! MessageTableViewCell
            return cell
        }
        
        let cellID = (message.author?.uid ?? 0 == session.uid) ? RUI_MessageFromSelf : RUI_MessageFromUser
        let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as! MessageTableViewCell
        configureCell(cell, withMessage: message)
        return cell
    }
    
    func configureCell(cell: MessageTableViewCell, withMessage message: CDWSMessage) {
        cell.fromLabel.text = message.authorName ?? ""
        cell.dateLabel.text = textForMessageDate(message.timestamp)
        cell.bodyTextView.text = message.body
        cell.authorImageView.image = message.authorThumbnail ?? UIImage(named: "ThumbnailPlaceholder")
    }
    
}