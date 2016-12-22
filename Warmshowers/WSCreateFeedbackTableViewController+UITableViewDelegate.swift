//
//  WSCreateFeedbackTableViewController+UITableViewDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 21/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

extension WSCreateFeedbackTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (indexPath as NSIndexPath).section == 0 {
            
            hideKeyboard()
            
            // show a picker
            let cell = tableView.cellForRow(at: indexPath)
            if cell?.reuseIdentifier == "FeedbackOption" {
                displayInlinePickerForRowAtIndexPath(indexPath)
            } else {
                tableView.deselectRow(at: indexPath, animated: true)
            }
        } else {
            
            tableView.deselectRow(at: indexPath, animated: true)
            removeAllPickerCells()
        }
    }
}
