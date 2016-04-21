//
//  CreateFeedbackTableViewController+UITableViewDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 21/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

extension CreateFeedbackTableViewController {
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 0 {
            
            hideKeyboard()
            
            // show a picker
            let cell = tableView.cellForRowAtIndexPath(indexPath)
            if cell?.reuseIdentifier == FeedbackOptionCellID {
                displayInlinePickerForRowAtIndexPath(indexPath)
            } else {
                tableView.deselectRowAtIndexPath(indexPath, animated: true)
            }
        } else {
            
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            removeAllPickerCells()
        }
    }
}