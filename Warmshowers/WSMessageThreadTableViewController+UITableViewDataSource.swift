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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController.sections else { return 0 }
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = self.fetchedResultsController.object(at: indexPath)
        let cellID = (message.author?.uid ?? 0 == session.uid) ? RUI_MessageFromSelf : RUI_MessageFromUser
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! MessageTableViewCell
        configureCell(cell, withMessage: message)
        return cell
    }
    
    func configureCell(_ cell: MessageTableViewCell, withMessage message: WSMOMessage) {
        cell.fromLabel.text = message.author?.fullname
        cell.dateLabel.text = textForMessageDate(message.timestamp)
        cell.bodyTextView.text = message.body
        cell.authorImageView.image = message.author?.image as? UIImage ?? UIImage(named: "ThumbnailPlaceholder")
    }
    
}
