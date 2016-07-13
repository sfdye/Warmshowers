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
        if let sections = fetchedResultsController.sections {
            let sectionInfo = sections[0]
            if sectionInfo.numberOfObjects == 0 {
                return CGFloat(100)
            }
        }
        return CGFloat.min
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section == 0 else { return nil }
        if let sections = fetchedResultsController.sections {
            let sectionInfo = sections[0]
            if sectionInfo.numberOfObjects == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier(RUID_NoMessageThreadsCell) as! PlaceholderTableViewCell
                cell.placeholderLabel.text = "No messages"
                return cell as UIView
            }
        }
        return nil
    }

}