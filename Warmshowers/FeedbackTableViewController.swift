//
//  FeedbackTableViewController.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 3/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

class FeedbackTableViewController: WSLazyImageTableViewController {

    var feedback: [AnyObject] { return lazyImageObjects }
    
    // MARK: View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 122
    }

}
