//
//  WSSettingsTableViewController+UITableViewDataSource.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 30/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

extension WSSettingsTableViewController {
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return settings[section]["section_title"] as? String
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return settings.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let cells = settings[section]["cells"]
        assert(cells != nil, "No cells found for settings sections \(section).")
        return cells?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cells = settings[indexPath.section]["cells"] as? [AnyObject]
        let contents = cells?[indexPath.row]
        let cellID = contents?["cell_id"] as! String
        switch cellID  {
        case SwitchCellID:
            let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as! SwitchTableViewCell
            cell.label?.text = contents?["title"] as? String
            cell.tag = contents!["tag"] as! Int
            return cell
        case DisclosureCellID:
            let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath)
            cell.textLabel!.text = contents?["title"] as? String
            cell.detailTextLabel!.text = contents?["detail"] as? String
            cell.tag = contents!["tag"] as! Int
            return cell
        case LogoutCellID:
            let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath)
            cell.tag = contents!["tag"] as! Int
            return cell
        default:
            let cell = UITableViewCell(style: .Default, reuseIdentifier: nil)
            return cell
        }
    }
}