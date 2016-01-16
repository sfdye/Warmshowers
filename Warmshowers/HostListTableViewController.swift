//
//  HostListTableViewController.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 13/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

let ToUserAccountSegueID = "FromListToUserAccount"
let HostListCellID = "HostList"

class HostListTableViewController: WSLazyImageTableViewController {
    
    var users: [AnyObject] { return lazyImageObjects }
    
    // MARK: View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        
        if users.count > 0 {
            self.navigationItem.title = "\(users.count) Hosts"
        } else {
            self.navigationItem.title = "Hosts"
            // No users in the data source. Dismiss the view with an error message
            let alert = UIAlertController(title: "Sorry, an error occured.", message: nil, preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "OK", style: .Default, handler: { (okAction) -> Void in
                self.dismissViewControllerAnimated(true, completion: nil)
            })
            alert.addAction(okAction)
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        // Configure the table view
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 74 
    }
    
    // MARK: Navigation
    
    @IBAction func doneButtonPressed() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if let cell = sender as? HostListTableViewCell {
            if let _ = cell.uid {
                return true
            }
        }
        return false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let cell = sender as? HostListTableViewCell
        let accountVC = segue.destinationViewController as! AccountTableViewController
        accountVC.uid = cell?.uid
    }
}
