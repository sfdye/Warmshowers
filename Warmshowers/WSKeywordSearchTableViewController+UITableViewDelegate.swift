//
//  WSKeywordSearchTableViewController+UITableViewDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 15/05/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

extension WSKeywordSearchTableViewController {
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CGFloat(74)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        guard
            let cell = tableView.cellForRowAtIndexPath(indexPath) as? HostListTableViewCell,
            let uid = cell.uid
            else { return }
        navigationDelegate?.showUserProfileForHostWithUID(uid)
    }
    
}
