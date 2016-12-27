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
                ProgressHUD.show("Logging out ...")
                api.contact(endPoint: .logout, withMethod: .post, andPathParameters: nil, andData: nil, thenNotify: self)
            case 50:
                ProgressHUD.show("Deleting data ...")
                do {
                    try store.clearout()
                } catch {
                    alert.presentAlertFor(self, withTitle: "Data Error", button: "OK", message: "Sorry, an error occured while removing your account data from your device. Please try deleting and re-installing the Warmshowers app and report this as a bug.", andHandler: nil)
                }
                ProgressHUD.hide()
            default:
                return
            }
        }
    }
}
