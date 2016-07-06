//
//  WSKeywordSearchTableViewController+UITableViewDataSource.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 15/05/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

extension WSKeywordSearchTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let _ = hosts else { return 1 }
        return numberOfHosts == 0 ? 1 : numberOfHosts
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let hosts = hosts else {
            let cell = tableView.dequeueReusableCell(withIdentifier: SpinnerCellID, for: indexPath) as! SpinnerTableViewCell
            cell.startSpinner()
            return cell
        }
        
        if numberOfHosts == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: NoHostsCellID, for: indexPath) as! PlaceholderTableViewCell
            cell.placeholderLabel.text = "No Hosts"
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: HostListCellID, for: indexPath) as! HostListTableViewCell
            let user = hosts[(indexPath as NSIndexPath).row]
            cell.nameLabel.text = user.fullname
            cell.locationLabel.text = user.shortAddress
            cell.setNotAvailible(user.notcurrentlyavailable)
            cell.profileImage.image = user.image ?? placeholderImage
            
            // Download the users thumbnail image if needed.
            if let _ = user.imageURL
                where user.image == nil && !tableView.isDragging && !tableView.isDecelerating {
                startImageDownloadForIndexPath(indexPath)
            }

            return cell
        }
    }
}
