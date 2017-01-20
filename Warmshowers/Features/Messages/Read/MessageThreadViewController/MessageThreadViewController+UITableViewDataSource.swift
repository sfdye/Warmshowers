//
//  MessageThreadViewController+UITableViewDataSource.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 27/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit
import CoreData
import WarmshowersData

extension MessageThreadViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let sections = fetchedResultsController?.sections else { return 0 }
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController?.sections, section < sections.count else { return 0 }
        return sections[section].numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Message", for: indexPath) as! MessageTableViewCell

        guard
            let message = self.fetchedResultsController?.object(at: indexPath) else {
            cell.fromLabel.text = nil
            cell.dateLabel.text = nil
            cell.bodyTextView.text = ""
            cell.authorImageView.image = UIImage(named: "ThumbnailPlaceholder")
            cell.uid = 0
            cell.delegate = self
            return cell
        }
        
        configureCell(cell, withMessage: message)
        return cell
    }
    
    func configureCell(_ cell: MessageTableViewCell, withMessage message: MOMessage) {
        cell.fromLabel.text = message.author?.fullname
        cell.dateLabel.text = textForMessageDate(message.timestamp)
        cell.bodyTextView.text = message.body
        cell.bodyTextView.textContainer.lineFragmentPadding = 0
        cell.authorImageView.image = message.author?.image as? UIImage ?? UIImage(named: "ThumbnailPlaceholder")
        cell.uid = message.author?.uid ?? 0
        cell.backgroundColor = (message.author?.uid ?? 0 == session.uid) ? .white : UIColor(colorLiteralRed: 246, green: 246, blue: 246, alpha: 1)
        cell.delegate = self
    }
    
}
