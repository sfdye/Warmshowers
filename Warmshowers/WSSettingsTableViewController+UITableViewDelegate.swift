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
            case 40:
                WSProgressHUD.show("Deleting data ...")
                do {
                    try store.clearout()
                } catch {
                    print(error)
                    alert.presentAlertFor(self, withTitle: "Data Error", button: "OK", message: "Sorry, an error occured while removing your account data from your device. Please try deleting and re-installing the Warmshowers app and report this as a bug.", andHandler: nil)
                }
                WSProgressHUD.hide()
            default:
                return
            }
        }
    }
}
