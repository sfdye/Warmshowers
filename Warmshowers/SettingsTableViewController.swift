//
//  SettingsTableViewController.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 19/11/15.
//  Copyright © 2015 Rajan Fernandez. All rights reserved.
//

import UIKit

/*

About
Help

 */

let LogoutCellID = "Logout"
let SwitchCellID = "Switch"
let DisclosureCellID = "Disclosure"

class SettingsTableViewController: UITableViewController {
    
    var wifiOnly = true
    
    var settings = [
//        [
//            "section_title" : "Map",
//            "cells" : [
//                [
//                    "title" : "Source",
//                    "cell_id": DisclosureCellID,
//                    "tag" : 00
//                ]
//            ]
//        ],
        [
            "section_title" : "Warmshowers.org",
            "cells" : Array([
                [
                    "title" : "Visit the website",
                    "cell_id": DisclosureCellID,
                    "tag" : 10
                ],
                [
                    "title": "FAQ",
                    "cell_id": DisclosureCellID,
                    "tag" : 11
                ]
            ])
        ],
        [
            "section_title" : "Help",
            "cells" : [
                [
                    "title" : "Contact",
                    "cell_id": DisclosureCellID,
                    "tag" : 20
                ]
            ]
        ],
        [
            "cells" : [
                [
                    "title" : "Logout",
                    "cell_id": LogoutCellID,
                    "tag" : 30
                ]
            ]
        ]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Settings"
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return settings.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings[section]["cells"]!.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let contents = settings[indexPath.section]["cells"]?[indexPath.row]
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
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return settings[section]["section_title"] as? String
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if let cell = tableView.cellForRowAtIndexPath(indexPath){
            switch cell.tag {
            case 10:
                UIApplication.sharedApplication().openURL(NSURL(string: "https://www.warmshowers.org")!)
            case 11:
                UIApplication.sharedApplication().openURL(NSURL(string: "https://www.warmshowers.org/faq")!)
            case 20:
                UIApplication.sharedApplication().openURL(NSURL(string: "mailto:rajan.fernandez@hotmail.com?subject=Warmshowers%20app")!)
            case 30:
                // Logout and return the login screeen
                let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
                
                // Logout and return the login screeen
                WSRequest.logout({ (success) -> Void in
                    
                    // Delete the users messages from the store
                    do {
                        try appDelegate?.clearStore()
                    } catch {
                        // Suggest that the user delete the app for privacy
                        let alert = UIAlertController(title: "Data Error", message: "Sorry, an error occured while removing your messages from this iPhone during the logout process. If you would like to remove your Warmshowers messages from this iPhone please try deleting the Warmshowers app.", preferredStyle: .Alert)
                        let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                        alert.addAction(okAction)
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.presentViewController(alert, animated: true, completion: nil)
                        })
                    }
                    
                    // Delete defaults and return to the login screen
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        appDelegate?.logout()
                    })
                })
                
            default:
                return
            }
        }
    }
    
}
