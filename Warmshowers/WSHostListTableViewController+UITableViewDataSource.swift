//
//  WSHostListTableViewController+UITableViewDataSource.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 16/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

extension WSHostListTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HostListCellID, for: indexPath)
        if (users?.count ?? 0) > 0 {
            if let user = users![(indexPath as NSIndexPath).row] as? WSUserLocation, let cell = cell as? HostListTableViewCell {
                cell.nameLabel.text = user.fullname
                cell.locationLabel.text = user.shortAddress
                cell.uid = user.uid
            }
        }
        return cell
    }
    
}
