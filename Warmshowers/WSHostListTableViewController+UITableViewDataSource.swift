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
        return hosts?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(HostListCellID, forIndexPath: indexPath) as! HostListTableViewCell
        guard let hosts = hosts else { return cell }
        
        let host = hosts[indexPath.row]
        cell.nameLabel.text = host.fullname
        cell.locationLabel.text = host.shortAddress
        cell.profileImage.image = host.image ?? placeholderImage
        cell.setNotAvailible(host.notcurrentlyavailable)
        cell.uid = host.uid
        
        // Download the hosts thumbnail image if needed.
        if let _ = host.imageURL
            where host.image == nil && !tableView.dragging && !tableView.decelerating {
            startImageDownloadForIndexPath(indexPath)
        }

        return cell
    }
    
}
