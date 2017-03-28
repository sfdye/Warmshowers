//
//  SettingsTableViewController+UITableViewDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 30/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

extension SettingsTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let cell = tableView.cellForRow(at: indexPath){
            switch cell.tag {
            case 10:
                let url = URL(string: "https://www.warmshowers.org")!
                navigation.open(url: url, fromViewController: self)
            case 11:
                let url = URL(string: "https://www.warmshowers.org/faq")!
                navigation.open(url: url, fromViewController: self)
            case 20:
                navigation.openFeedbackEmail()
            case 30:
                performSegue(withIdentifier: SID_SettingsToRoutes, sender: nil)
            case 40:
                let label = NSLocalizedString("Logging out ...", tableName: "Settings", comment: "Label shown with the spinner while logging out")
                ProgressHUD.show(label)
                api.contact(endPoint: .logout, withMethod: .post, andPathParameters: nil, andData: nil, thenNotify: self, ignoreCache: false)
            case 50:
                let label = NSLocalizedString("Deleting data ...", tableName: "Settings", comment: "Label shown with the spinner while deleting cached data")
                ProgressHUD.show(label)
                do {
                    try store.clearout()
                } catch {
                    let title = NSLocalizedString("Data Error", comment: "Alert title for a data error")
                    let message = NSLocalizedString("Sorry, an error occured while removing your account data from your device. Please try deleting and re-installing the Warmshowers app and report this as a bug.", tableName: "Settings", comment: "Alert message for a data error")
                    let button = NSLocalizedString("OK", comment: "OK button title")
                    alert.presentAlertFor(self, withTitle: title, button: button, message: message, andHandler: nil)
                }
                ProgressHUD.hide()
            default:
                return
            }
        }
    }
}
