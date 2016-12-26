//
//  SettingsTableViewController+UITableViewDataSource.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 30/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

extension SettingsTableViewController {
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return settings[section].title
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return settings.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings[section].cells.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let content = settings[indexPath.section].cells[indexPath.row]
        let cellID = content.cellID
        switch cellID  {
        case "Switch":
            let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! SwitchTableViewCell
            cell.label?.text = content.title
            cell.tag = content.tag
            return cell
        case "Disclosure":
            let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
            cell.textLabel!.text = content.title
            cell.detailTextLabel!.text = content.detail
            cell.tag = content.tag
            return cell
        case "Logout":
            let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! LogoutTableViewCell
            cell.label?.text = content.title
            cell.tag = content.tag
            return cell
        default:
            let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
            return cell
        }
    }
}
