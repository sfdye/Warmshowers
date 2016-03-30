//
//  FeedbackTableViewController+UITableViewCellDataSource.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 16/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

extension FeedbackTableViewController : WSLazyImageTableViewDataSource {
    
    func lazyImageCellForIndexPath(indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(FeedbackCellID, forIndexPath: indexPath)
        if let feedback = feedback[indexPath.row] as? WSRecommendation, let cell = cell as? FeedbackTableViewCell {
            cell.configureWithFeedback(feedback)
        }
        return cell
    }
    
}
