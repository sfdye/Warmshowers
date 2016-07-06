//
//  WSHostListTableViewController.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 13/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

class WSHostListTableViewController: UITableViewController {
    
    var users: [WSUserLocation]?
        
    // MARK: View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if users!.count > 0 {
            self.navigationItem.title = "\(users!.count) Hosts"
        } else {
            self.navigationItem.title = "Hosts"
            // No users in the data source. Dismiss the view with an error message
            let alert = UIAlertController(title: "Sorry, an error occured.", message: nil, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: { (okAction) -> Void in
                self.dismiss(animated: true, completion: nil)
            })
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
        
        // Configure the table view
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 74 
    }
    
    // MARK: Navigation
    
    @IBAction func doneButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: AnyObject?) -> Bool {
        if let cell = sender as? HostListTableViewCell {
            if let _ = cell.uid {
                return true
            }
        }
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        let cell = sender as? HostListTableViewCell
        let accountTVC = segue.destinationViewController as! WSAccountTableViewController
        accountTVC.uid = cell?.uid
    }
}
