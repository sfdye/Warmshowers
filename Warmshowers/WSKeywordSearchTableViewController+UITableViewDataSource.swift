//
//  WSKeywordSearchTableViewController+UITableViewDataSource.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 15/05/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

extension WSKeywordSearchTableViewController {
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let _ = hosts else { return 1 }
        return numberOfHosts == 0 ? 1 : numberOfHosts
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        guard let hosts = hosts else {
            let cell = tableView.dequeueReusableCellWithIdentifier(SpinnerCellID, forIndexPath: indexPath)
            return cell
        }
        
        if numberOfHosts == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(NoHostsCellID, forIndexPath: indexPath) as! PlaceholderTableViewCell
            cell.placeholderLabel.text = "No Hosts"
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(HostListCellID, forIndexPath: indexPath) as! HostListTableViewCell
            let user = hosts[indexPath.row]
            cell.nameLabel.text = user.fullname
            cell.locationLabel.text = user.shortAddress
            cell.setNotAvailible(user.notcurrentlyavailable)
            cell.profileImage.image = user.thumbnailImage ?? placeholderImage
            
            // Download the users thumbnail image if needed.
            if let _ = user.thumbnailImageURL
                where user.thumbnailImage == nil && !tableView.dragging && !tableView.decelerating {
                startImageDownloadForIndexPath(indexPath)
            }

            return cell
        }
    }
}
