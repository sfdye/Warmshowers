//
//  HostSearchViewController+UITableViewDataSource.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 30/11/15.
//  Copyright © 2015 Rajan Fernandez. All rights reserved.
//

import Foundation

extension HostSearchViewController : WSLazyImageTableViewDataSource {
    
    func numberOfRowsInSection(section: Int) -> Int {
        if debounceTimer != nil || hostsInTable.count == 0 {
            return 1
        } else {
            return hostsInTable.count
        }
    }
    
    func lazyImageCellForIndexPath(indexPath: NSIndexPath) -> UITableViewCell {
        if debounceTimer != nil {
            let cell = tableView.dequeueReusableCellWithIdentifier(SpinnerCellID, forIndexPath: indexPath) as! SpinnerTableViewCell
            cell.startSpinner()
            return cell
        } else if hostsInTable.count == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(NoHostsCellID, forIndexPath: indexPath) as! NoHostsTableViewCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(HostListCellID, forIndexPath: indexPath)
            if hostsInTable.count > 0 && hostsInTable.count > indexPath.row {
                let user = hostsInTable[indexPath.row]
                if let cell = cell as? HostListTableViewCell {
                    cell.nameLabel.text = user.fullname
                    cell.locationLabel.text = user.shortAddress
                    cell.uid = user.uid
                }
            }
            return cell
        }
    }
}