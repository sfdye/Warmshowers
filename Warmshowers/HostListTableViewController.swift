//
//  HostListTableViewController.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 13/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

class HostListTableViewController: UITableViewController {
    
    let ToUserAccountSegueID = "FromListToUserAccount"
    let HostListCellID = "HostList"
    
    var users: [WSUserLocation]?
    
    // MARK: View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let users = users {
            self.navigationItem.title = "\(users.count) Hosts"
        } else {
            self.navigationItem.title = "Hosts"
        }
        
        // Configure the table view
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return users == nil ? 0 : 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users == nil ? 0 : users!.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(HostListCellID, forIndexPath: indexPath) as! HostListTableViewCell
        cell.configureWithUserLocation(users![indexPath.row])
        return cell
    }
    
    // MARK: Navigation
    
    @IBAction func doneButtonPressed() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let cell = sender as! HostListTableViewCell
        let row = tableView.indexPathForCell(cell)!.row
        let accountTVC = segue.destinationViewController as! AccountTableViewController
        accountTVC.uid = users?[row].uid
    }
    

}
