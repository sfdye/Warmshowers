//
//  FeedbackTableViewController+UITableViewCellDataSource.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 16/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

extension FeedbackTableViewController {
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(FeedbackCellID, forIndexPath: indexPath)
        
        setLazyImageForCell(cell, atIndexPath: indexPath)
        
        if let feedback = feedback[indexPath.row] as? WSRecommendation, let cell = cell as? FeedbackTableViewCell {
            cell.configureWithFeedback(feedback)
        }
        
        return cell
    }
    
}
