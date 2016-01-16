//
//  HostSearchViewController+UITableViewDataSource.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 30/11/15.
//  Copyright © 2015 Rajan Fernandez. All rights reserved.
//

import Foundation

extension HostSearchViewController : WSLazyImageTableViewDataSource {
    
    func lazyImageCellForIndexPath(indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(HostListCellID, forIndexPath: indexPath)
        if hostsInTable.count > 0 && hostsInTable.count > indexPath.row {
            let user = hostsInTable[indexPath.row]
            if let cell = cell as? HostListTableViewCell {
                cell.nameLabel.text = user.fullname
                cell.locationLabel.text = user.address
                cell.uid = user.uid
            }
        }
        return cell
    }
}