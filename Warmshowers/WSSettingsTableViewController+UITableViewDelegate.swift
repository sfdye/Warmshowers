//
//  WSSettingsTableViewController+UITableViewDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 30/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

extension WSSettingsTableViewController {
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if let cell = tableView.cellForRowAtIndexPath(indexPath){
            switch cell.tag {
            case 10:
                navigationDelegate?.openWarmshowersHomePage()
            case 11:
                navigationDelegate?.openWarmshowersFAQPage()
            case 20:
                navigationDelegate?.openFeedbackEmail()
            case 30:
                WSProgressHUD.show("Logging out ...")
                apiCommunicator?.logoutAndNotify(self)
            default:
                return
            }
        }
    }
}
