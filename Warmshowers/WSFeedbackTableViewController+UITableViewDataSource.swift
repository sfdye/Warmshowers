//
//  WSFeedbackTableViewController+UITableViewCellDataSource.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 16/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

extension WSFeedbackTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedback?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FeedbackCellID, for: indexPath) as! FeedbackTableViewCell
        if let feedback = feedback?[(indexPath as NSIndexPath).row] {
            cell.configureWithFeedback(feedback)
        }
        return cell
    }
    
}
