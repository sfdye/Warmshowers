//
//  WSHostListTableViewController+UITableViewDataSource.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 16/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

extension WSHostListTableViewController {
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(HostListCellID, forIndexPath: indexPath)
        guard (users?.count ?? 0) > 0 else { return cell }
        
        let user = users?[indexPath.row]
        
        if let user = user, cell = cell as? HostListTableViewCell {
            cell.nameLabel.text = user.fullname
            cell.locationLabel.text = user.shortAddress
            cell.uid = user.uid
        }
        return cell
    }
    
}
