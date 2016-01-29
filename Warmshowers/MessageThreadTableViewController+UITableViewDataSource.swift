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
        return count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let message = CDWSMessageThread.messageAtIndexPath(indexPath, onMessageThreadWithID: threadID) {
            let cellID = (message.author!.uid == currentUserUID) ? MessageFromSelfCellID : MessageFromUserCellID
            let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as! MessageTableViewCell
            cell.configureWithMessage(message)
            return cell
        } else {
            let cell = UITableViewCell()
            return cell
        }
    }
    
}