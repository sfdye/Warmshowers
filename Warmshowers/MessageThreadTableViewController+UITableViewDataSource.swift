//
//  MessageThreadTableViewController+UITableViewDataSource.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 27/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

extension MessageThreadTableViewController {
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sections = self.fetchedResultsController.sections!
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let message = self.fetchedResultsController.objectAtIndexPath(indexPath) as! CDWSMessage
        let cellID = (message.author!.uid == currentUserUID) ? MessageFromSelfCellID : MessageFromUserCellID
        let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as! MessageTableViewCell
        self.configureCell(cell, indexPath: indexPath)
        return cell
    }
    
    func configureCell(cell: UITableViewCell, indexPath: NSIndexPath) {
        let message = self.fetchedResultsController.objectAtIndexPath(indexPath) as! CDWSMessage
        (cell as! MessageTableViewCell).configureWithMessage(message)
    }
    
}