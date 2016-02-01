//
//  MessageThreadsTableViewController.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 1/12/15.
//  Copyright © 2015 Rajan Fernandez. All rights reserved.
//

import UIKit
import CoreData
import MBProgressHUD

let MESSAGE_THREAD_CELL_ID = "MessageThreadCell"
let MESSAGE_SEGUE_ID = "ToMessageThread"

class MessageThreadsTableViewController: UITableViewController {
    
    // MARK: Properties

    var currentUserUID: Int {
        let defaults = NSUserDefaults.standardUserDefaults()
        return defaults.integerForKey(defaults_key_uid)
    }
    var count: Int = 0
    
    var messageThreadUpdater: WSMessageThreadsUpdater!
    var lastUpdated: NSDate?
//    var updatesQueue = NSOperationQueue()
    var updatesInProgress = [Int: WSMessageUpdater]()
    var alert: UIAlertController?
    var presentingAlert = false
    
    
    // MARK: View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Messages"
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: WSColor.Green, NSFontAttributeName: WSFont.SueEllenFrancisco(26)]
        
        // Set the refresh controller for the tableview
        let refreshController = UIRefreshControl()
        refreshController.addTarget(self, action: Selector("update"), forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = refreshController

        // Set up the message thread updater
        messageThreadUpdater = WSMessageThreadsUpdater()
        messageThreadUpdater.success = {
            self.lastUpdated = NSDate()
            self.updateAllMessages()
        }
        messageThreadUpdater.failure = { (error) -> Void in
            self.reload()
            self.setFailedUpdateAlert(error)
            self.showAlert()
        }
        WSProgressHUD.show("Updating messages ...")
        
        // Table view autolayout options
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 96
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: WSColor.Green, NSFontAttributeName: WSFont.SueEllenFrancisco(26)]
    }
    
    override func viewDidAppear(animated: Bool) {
        
        var needsUpdate = false
        
        // Update the message threads if more than 10 minutes has elapsed
        if lastUpdated == nil {
            needsUpdate = true
        } else if lastUpdated!.timeIntervalSinceNow > 600 {
            needsUpdate = true
        }
        
        if needsUpdate {
            update()
        } else {
            reload()
        }
    }
    
    
    // MARK: Utility methods
    
    func update() {
        messageThreadUpdater.update()
    }
    
    func reload() {
        
        // Hide any activity indicators
        self.refreshControl!.endRefreshing()
        WSProgressHUD.hide()
        
        // Update the view
        do {
            count = try CDWSMessageThread.numberOfMessageThreads()
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                self.tableView.reloadData()
                self.updateTabBarBadge()
            }
        } catch let error {
            let nserror = error as NSError
            setFailedUpdateAlert(nserror)
        }
        
        // Show any errors
        showAlert()
    }
    
    // Updates the messages on each thread if required
    //
    func updateAllMessages() {
        
        // Update the messages if necessary
        do {
            if let threadIDs = try CDWSMessageThread.messageThreadsThatNeedUpdating() {
                for threadID in threadIDs {
                    self.updateMessagesOnThread(threadID)
                }
            } else {
                reload()
            }
        } catch let error  {
            let nserror = error as NSError
            setFailedUpdateAlert(nserror)
            reload()
        }
    }
    
    // Cancels all message update requests
    //
    func cancelAllUpdates() {
        for (_, update) in updatesInProgress {
            update.cancel()
        }
    }
    
    // Sets an updater for a message thread, but does not start it
    //
    func updateMessagesOnThread(threadID: Int) {
        
        guard updatesInProgress[threadID] == nil else {
            print("already updating thread")
            return
        }
        
        let messageUpdater = WSMessageUpdater(threadID: threadID)
        messageUpdater.success = {
            self.updateFinishedForThreadID(threadID)
        }
        messageUpdater.failure = { (error) -> Void in
            self.cancelAllUpdates()
            self.setFailedUpdateAlert(error)
            self.updateFinishedForThreadID(threadID)
        }
        updatesInProgress[threadID] = messageUpdater
        messageUpdater.update()
    }

    // Removes the message updater object assign to a given thread and reloads the table if all updates are done
    //
    func updateFinishedForThreadID(threadID: Int) {
        
        // Remove the updater
        self.updatesInProgress.removeValueForKey(threadID)
        
        // Reload the table view if all the updates are finished
        if updatesInProgress.count == 0 {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.reload()
            })
        }
    }
    
    // Update the tab bar badge with the number of unread threads
    //
    func updateTabBarBadge() {
        let unread = CDWSMessageThread.numberOfUnreadMessageThreads()
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            if unread > 0 {
                self.navigationController?.tabBarItem.badgeValue = String(unread)
            } else {
                self.navigationController?.tabBarItem.badgeValue = nil
            }
        }
    }
    
    // Sets an failed update alert to be displayed at the end of the updates
    //
    func setFailedUpdateAlert(error: NSError? = nil) {
        
        guard alert == nil else {
            return
        }
        
        if !presentingAlert {
            var message: String = "Please check that you are connected to the internet and try again."
            if let error = error {
                message = error.localizedDescription
            }
            let alert = UIAlertController(title: "Failed to update messages", message: message, preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alert.addAction(okAction)
            self.alert = alert
        }
    }
    
    // Presents any alerts set during message updates
    //
    func showAlert() {

        guard let alert = alert else {
            return
        }
        
        if !presentingAlert {
            presentingAlert = true
            dispatch_async(dispatch_get_main_queue(), {
                self.presentViewController(alert, animated: true, completion: { () -> Void in
                    self.alert = nil
                    self.presentingAlert = false
                })
            })
        }
    }
    
    
    // MARK: Navigation
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if identifier == MESSAGE_SEGUE_ID {
            if let cell = sender as? MessageThreadsTableViewCell {
                if cell.threadID != nil {
                    return true
                }
            }
        }
        return false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == MESSAGE_SEGUE_ID {
            
            let cell = sender as? MessageThreadsTableViewCell
            
            // Assign the message thread data to the destination view controller
            let messageThreadVC = segue.destinationViewController as! MessageThreadTableViewController
            messageThreadVC.threadID = cell?.threadID
        }
    }
    
}
