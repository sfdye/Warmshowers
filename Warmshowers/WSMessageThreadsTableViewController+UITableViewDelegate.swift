//
//  WSMessageThreadsTableViewController+UITableViewDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 27/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

extension WSMessageThreadsTableViewController {
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CGFloat(100)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let sections = fetchedResultsController?.sections else { return CGFloat.min }
        let sectionInfo = sections[0]
        if sectionInfo.numberOfObjects == 0 {
            return CGFloat(100)
        } else {
            return CGFloat.min
        }
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section == 0 else { return nil }
        guard let sections = fetchedResultsController?.sections else { return nil }
        let sectionInfo = sections[0]
        if sectionInfo.numberOfObjects == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(RUID_NoMessageThreadsCell) as! PlaceholderTableViewCell
            cell.placeholderLabel.text = "No messages"
            return cell as UIView
        } else {
            return nil
        }
        
    }

}