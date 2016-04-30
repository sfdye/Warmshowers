//
//  WSHostSearchViewController+UITableViewDataSource.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 30/11/15.
//  Copyright © 2015 Rajan Fernandez. All rights reserved.
//

import UIKit

extension WSHostSearchViewController : WSLazyImageTableViewDataSource {
    
    func numberOfRowsInSection(section: Int) -> Int {
        if debounceTimer != nil || tableViewController.lazyImageObjects.count == 0 {
            return 1
        } else {
            return tableViewController.lazyImageObjects.count
        }
    }
    
    func lazyImageCellForIndexPath(indexPath: NSIndexPath) -> UITableViewCell {
        if debounceTimer != nil {
            let cell = tableView.dequeueReusableCellWithIdentifier(SpinnerCellID, forIndexPath: indexPath) as! SpinnerTableViewCell
            cell.startSpinner()
            return cell
        } else if tableViewController.lazyImageObjects.count == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(PlaceholderCellID, forIndexPath: indexPath) as! PlaceholderTableViewCell
            cell.placeholderLabel.text = "No Hosts"
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(HostListCellID, forIndexPath: indexPath) as! HostListTableViewCell
            if tableViewController.lazyImageObjects.count > 0 && tableViewController.lazyImageObjects.count > indexPath.row {
                let user = tableViewController.lazyImageObjects[indexPath.row] as! WSUserLocation
                cell.nameLabel.text = user.fullname
                cell.locationLabel.text = user.shortAddress
                cell.setNotAvailible(user.notcurrentlyavailable)
                cell.uid = user.uid
                return cell
            } else {
                cell.nameLabel.text = nil
                cell.locationLabel.text = nil
                cell.imageView!.image = nil
                cell.availibleDot!.hidden = true
                return cell
            }
        }
    }
}