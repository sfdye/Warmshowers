//
//  WSMessageThreadTableViewController+UITableViewDataSource.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 27/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

extension WSMessageThreadTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sections = self.fetchedResultsController.sections!
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = self.fetchedResultsController.object(at: indexPath) as! CDWSMessage
        let cellID = (message.author!.uid == session.uid) ? MessageFromSelfCellID : MessageFromUserCellID
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! MessageTableViewCell
        self.configureCell(cell, indexPath: indexPath)
        return cell
    }
    
    func configureCell(_ cell: UITableViewCell, indexPath: IndexPath) {
        let message = self.fetchedResultsController.object(at: indexPath) as! CDWSMessage
        (cell as! MessageTableViewCell).configureWithMessage(message)
    }
    
}
