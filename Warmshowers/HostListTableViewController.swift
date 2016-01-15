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

class HostListTableViewController: UITableViewController {
    
    var users = [WSUserLocation]()
    var thumbnailDownloadsInProgress = [NSIndexPath: WSImageDownloader]()
    
    // MARK: View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if users.count > 0 {
            self.navigationItem.title = "\(users.count) Hosts"
        } else {
            self.navigationItem.title = "Hosts"
        }
        
        // Configure the table view
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
        
    }
    
    
    // MARK: Utiliies 
    
    // Downloads a users thumbnail size profile image and updates the table view data source
    //
    func startThumbnailDownload(user: WSUserLocation, indexPath: NSIndexPath) {
        
        if thumbnailDownloadsInProgress[indexPath] == nil {
            
            // Create and start a thumbnailDownloader object
            let thumbnailDownloader = WSImageDownloader()
            thumbnailDownloader.user = user
            thumbnailDownloader.completionHandler = {
                
                // Update the cell with the users profile image
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    // Sometimes this cast failes for the first screen of the tableview, but i don't know why.
                    if let cell = self.tableView.cellForRowAtIndexPath(indexPath) as? HostListTableViewCell {
                        cell.profileImage.image = user.thumbnailImage
                    }
                })
                
                // Remove the downloader object from the downloads
                self.thumbnailDownloadsInProgress.removeValueForKey(indexPath)
            }
            thumbnailDownloadsInProgress[indexPath] = thumbnailDownloader
            thumbnailDownloader.startDownload()
        }
    }
    
    // Tries to download all the profile images for the users on the screen
    func loadThumbnailsForUsersOnScreen() {
        
        guard let visiblePaths = tableView.indexPathsForVisibleRows else {
            return
        }
        for indexPath in visiblePaths {
            let user = users[indexPath.row]
            if user.thumbnailImage == nil {
                startThumbnailDownload(user, indexPath: indexPath)
            }
        }
    }
    
    // MARK: Navigation
    
    @IBAction func doneButtonPressed() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        let cell = sender as! HostListTableViewCell
        let row = tableView.indexPathForCell(cell)!.row
        return users.count > row
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let cell = sender as! HostListTableViewCell
        let row = tableView.indexPathForCell(cell)!.row
        let accountTVC = segue.destinationViewController as! AccountTableViewController
        accountTVC.uid = users[row].uid
    }
    

}
