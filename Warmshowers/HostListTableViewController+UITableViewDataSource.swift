//
//  ostListTableViewController+UITableViewDataSource.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 15/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

extension HostListTableViewController {
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(HostListCellID, forIndexPath: indexPath) as! HostListTableViewCell
        
        let user = users[indexPath.row]
        
        // Set the users name and address
        cell.nameLabel.text = user.fullname
        cell.locationLabel.text = user.address
        
        // Show the users profile image or a placholder
        if let thumbnail = user.thumbnailImage {
            cell.profileImage.image = thumbnail
        } else {
            // Defer downloading thumbnails until scrolling ends
            if tableView.dragging == false && tableView.decelerating == false {
                startThumbnailDownload(user, indexPath: indexPath)
            }
            cell.profileImage.image = UIImage(named: "ThumbnailPlaceholder")
        }
        
        return cell
    }
    
}