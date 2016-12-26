//
//  HostListTableViewController+UITableViewDataSource.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 16/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

extension HostListTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hosts?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HostList", for: indexPath) as! HostListTableViewCell
        guard let hosts = hosts else { return cell }
        
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
