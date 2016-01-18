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
                WSRequest.logout({ (success) -> Void in
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        appDelegate?.logout()
                    })
                })
            default:
                return
            }
        }
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

}
