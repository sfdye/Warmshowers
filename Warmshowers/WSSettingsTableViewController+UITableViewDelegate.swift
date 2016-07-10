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
                navigation.openWarmshowersHomePage()
            case 11:
                navigation.openWarmshowersFAQPage()
            case 20:
                navigation.openFeedbackEmail()
            case 30:
                WSProgressHUD.show("Logging out ...")
                api.contactEndPoint(.Logout, withPathParameters: nil, andData: nil, thenNotify: self)
            default:
                return
            }
        }
    }
}
