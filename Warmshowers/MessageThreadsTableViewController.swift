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
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var messageThreadUpdater: WSMessageThreadsUpdater!

    var lastUpdated: NSDate?
    var updatesInProgress = [Int: WSMessageThreadUpdater]()
    var alert: UIAlertController?
    
    
    // MARK: View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Messages"
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: WSColor.Green, NSFontAttributeName: WSFont.SueEllenFrancisco(26)]
        
        // Set the refresh controller for the tableview
        let refreshController = UIRefreshControl()
        refreshController.addTarget(self, action: Selector("updateMessages"), forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = refreshController

        // Set up the message thread updater
        messageThreadUpdater = WSMessageThreadsUpdater()
        messageThreadUpdater.success = {
            self.refreshControl!.endRefreshing()
            WSProgressHUD.hide()
            self.lastUpdated = NSDate()
            self.reload()
            print("Done.")
        }
        messageThreadUpdater.failure = { (error) -> Void in
            self.refreshControl!.endRefreshing()
            WSProgressHUD.hide()
            self.setFailedUpdateAlert(error)
            self.showAlert()
            print("fail")
        }
        WSProgressHUD.show("Updating messages ...")
        messageThreadUpdater.update()
        
        // Table view autolayout options
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 96
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: WSColor.Green, NSFontAttributeName: WSFont.SueEllenFrancisco(26)]
    }
    
    override func viewDidAppear(animated: Bool) {
        
//        var needsUpdate = false
//        
//        // Update the message threads if more than 10 minutes has elapsed
//        if lastUpdated == nil {
//            needsUpdate = true
//        } else if lastUpdated!.timeIntervalSinceNow > 600 {
//            needsUpdate = true
//        }
        
        tableView.reloadData()
        updateTabBarBadge()
    }
    
    func updateMessages() {
        messageThreadUpdater.update()
    }
    
    func reload() {
        count = CDWSMessageThread.numberOfMessageThreads()
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            print(self.count)
            self.updateTabBarBadge()
            self.tableView.reloadData()
        }
    }
    
    
    // MARK: Utility methods
    
//    // Starts updating message threads
//    //
//    func startUpdates() {
//        messageThreadUpdater.tokenGetter.start()
//    }
//    
//    // Fetches all messages from the store and updates the tableview data
//    //
//    func updateDataSource() {
//        
//        // Clear the context / table view data source
//        messageThreads = [CDWSMessageThread]()
//        
//        // Get the currently saved message threads from the store
//        let request = NSFetchRequest(entityName: "MessageThread")
//        do {
//            messageThreads = try moc.executeFetchRequest(request) as! [CDWSMessageThread]
//        } catch {
//            print("fetch fail.")
//        }
//        
//        // Sort the message threads
//        sortMessageThreads()
//    }
//    
//    func sortMessageThreads() {
//        
//        // Sort the messages by date
//        messageThreads.sortInPlace({
//            return $0.last_updated!.laterDate($1.last_updated!).isEqualToDate($0.last_updated!)
//        })
//        
//    }
//    
//    // Checks that messages in each thread are up-to-date an downloads required messages
//    //
//    func updateMessages() {
//        
//        for thread in messageThreads {
//            if thread.needsUpdating() {
//                setUpdaterForThread(thread)
//            }
//        }
//        startAllMessageUpdaters()
//    }
//    
//    // Sets an updater for a message thread, but does not start it
//    //
//    func setUpdaterForThread(messageThread: CDWSMessageThread) {
//        
//        guard let threadID = messageThread.thread_id?.integerValue else {
//            return
//        }
//        
//        let messageUpdater = WSMessageThreadUpdater(messageThread: messageThread, queue: queue)
//        messageUpdater.success = {
//            self.updateFinishedForThreadID(threadID)
//        }
//        messageUpdater.failure = {
//            let messageUpdater = self.updatesInProgress[threadID]
//            self.setFailedUpdateAlert(messageUpdater?.error)
//            self.updateFinishedForThreadID(threadID)
//        }
//        updatesInProgress[threadID] = messageUpdater
//    }
//    
//    // Starts all updaters in the updates in progress dictionary
//    //
//    func startAllMessageUpdaters() {
//        
//        guard updatesInProgress.count > 0 else {
//            return
//        }
//        
//        for (_, update) in updatesInProgress {
//            update.tokenGetter.start()
//        }
//    }
//    
//    // Removes the message updater object assign to a given thread and reloads the table if all updates are done
//    //
//    func updateFinishedForThreadID(threadID: Int) {
//        self.updatesInProgress.removeValueForKey(threadID)
//        self.reloadIfUpdatesAreFinished()
//    }
//    
//    // Reloads the table view if there are no message updaters left in updatesInProgress
//    //
//    func reloadIfUpdatesAreFinished() {
//        if updatesInProgress.count == 0 {
//            dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                
//                // Reload the table view
//                self.tableView.reloadData()
//                
//                // Hide refreshing indicators and show any error alerts that were set
//                self.refreshControl!.endRefreshing()
//                WSProgressHUD.hide()
//                self.showAlert()
//            })
//        }
//    }
    
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
        if alert == nil {
            var message: String = "Please check that you are connected to the internet and try again."
            if let error = error {
                message = error.localizedDescription
            }
            alert = UIAlertController(title: "Failed to update messages", message: message, preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alert!.addAction(okAction)
        }
    }
    
    // Presents any alerts set during message updates
    //
    func showAlert() {
        
        guard let alert = alert else {
            return
        }
        
        dispatch_async(dispatch_get_main_queue(), {
            self.presentViewController(alert, animated: true, completion: { () -> Void in
                self.alert = nil
            })
        })
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
