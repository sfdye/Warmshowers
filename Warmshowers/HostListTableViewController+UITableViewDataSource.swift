//
//  HostListTableViewController+UITableViewDataSource.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 16/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

extension HostListTableViewController {
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(HostListCellID, forIndexPath: indexPath)
        
        setLazyImageForCell(cell, atIndexPath: indexPath)
        
        if users.count > 0 {
            if let user = users[indexPath.row] as? WSUserLocation, let cell = cell as? HostListTableViewCell {
                cell.nameLabel.text = user.fullname
                cell.locationLabel.text = user.address
                cell.uid = user.uid
            }
        }
        
        return cell
    }
}
