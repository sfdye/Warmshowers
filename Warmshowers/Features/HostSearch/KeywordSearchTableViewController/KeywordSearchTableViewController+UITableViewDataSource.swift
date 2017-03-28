//
//  KeywordSearchTableViewController+UITableViewDataSource.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 15/05/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

extension KeywordSearchTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let _ = hosts else { return 1 }
        return numberOfHosts == 0 ? 1 : numberOfHosts
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let hosts = hosts else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Spinner", for: indexPath) as! SpinnerTableViewCell
            cell.startSpinner()
            return cell
        }
        
        if numberOfHosts == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoHosts", for: indexPath) as! PlaceholderTableViewCell
            cell.placeholderLabel.text = NSLocalizedString("No Hosts", tableName: "HostSearch",
                                                           comment: "Text displayed when no hosts are returned for a keyword search")
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HostList", for: indexPath) as! HostListTableViewCell
            let host = hosts[(indexPath as NSIndexPath).row]
            cell.nameLabel.text = host.fullname
            cell.locationLabel.text = host.shortAddress
            cell.profileImage.image = host.image ?? placeholderImage
            cell.setNotAvailible(host.notcurrentlyavailable)
            cell.uid = host.uid
            
            // Download the hosts thumbnail image if needed.
            if let _ = host.imageURL
                , host.image == nil && !tableView.isDragging && !tableView.isDecelerating {
                startImageDownloadForIndexPath(indexPath)
            }

            return cell
        }
    }
}
