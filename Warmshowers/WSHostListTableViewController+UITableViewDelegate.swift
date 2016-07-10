//
//  WSHostListTableViewController+UITableViewDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 10/07/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

extension WSHostListTableViewController {
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        guard
            let cell = tableView.cellForRowAtIndexPath(indexPath) as? HostListTableViewCell,
            let uid = cell.uid
            else { return }
        showUserProfileForHostWithUID(uid)
    }
}
