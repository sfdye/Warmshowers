//
//  WSHostListTableViewController.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 13/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

class WSHostListTableViewController: UITableViewController {
    
    var placeholderImage: UIImage? = UIImage(named: "ThumbnailPlaceholder")
    var hosts: [WSUserLocation]?
    var numberOfHosts: Int { return hosts?.count ?? 0 }
    
    // Delegates
    var api: WSAPICommunicator? = WSAPICommunicator.sharedAPICommunicator
    
    // MARK: View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure the table view
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 74
        
        guard let hosts = hosts where hosts.count > 0 else {
            self.navigationItem.title = "Hosts"
            // No users in the data source. Dismiss the view with an error message
            let alert = UIAlertController(title: "Sorry, an error occured.", message: nil, preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "OK", style: .Default, handler: { (okAction) -> Void in
                self.dismissViewControllerAnimated(true, completion: nil)
            })
            alert.addAction(okAction)
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        self.navigationItem.title = "\(hosts.count) Hosts"
    }
    
    // MARK: Utilities
    
    func startImageDownloadForIndexPath(indexPath: NSIndexPath) {
        
        guard let hosts = hosts where indexPath.row < numberOfHosts else {
            return
        }
        
        let user = hosts[indexPath.row]
        if let url = user.imageURL where user.image == nil {
            api?.getImageAtURL(url, andNotify: self)
        }
    }
    
    func loadImagesForObjectsOnScreen() {
        
        guard
            let visiblePaths = tableView.indexPathsForVisibleRows
            where hosts != nil && numberOfHosts > 0
            else {
                return
        }
        
        for indexPath in visiblePaths {
            startImageDownloadForIndexPath(indexPath)
        }
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
        let accountTVC = segue.destinationViewController as! WSAccountTableViewController
        accountTVC.uid = cell?.uid
    }
}
