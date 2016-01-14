//
//  HostSearchViewController+UITableViewDataSource.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 30/11/15.
//  Copyright © 2015 Rajan Fernandez. All rights reserved.
//

import Foundation

extension HostSearchViewController : UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active && searchController.searchBar.text != "" {
            print("\(hostsInTable.count) hosts")
            return hostsInTable.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("HostList", forIndexPath: indexPath) as! HostListTableViewCell
        cell.nameLabel.text = hostsInTable[indexPath.row].fullname
        return cell
    }
    
}