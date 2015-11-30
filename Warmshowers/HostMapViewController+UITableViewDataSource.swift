//
//  HostMapViewController+UITableViewDataSource.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 30/11/15.
//  Copyright © 2015 Rajan Fernandez. All rights reserved.
//

import Foundation

extension HostMapViewController : UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init()
        return cell
    }
    
}