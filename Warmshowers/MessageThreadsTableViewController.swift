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

let MessageThreadCellID = "MessageThreadCell"
let MessageSegueID = "ToMessageThread"

class MessageThreadsTableViewController: UITableViewController {
    
    // MARK: Properties

    var currentUserUID: Int {
        let defaults = NSUserDefaults.standardUserDefaults()
        return defaults.integerForKey(defaults_key_uid)
    }
    var count: Int = 0
    
    var messageThreadUpdater: WSMessageThreadsUpdater!
    let store = WSMessageStore()
    var lastUpdated: NSDate?
    var updatesInProgress = [Int: WSMessageUpdater]()
    var alert: UIAlertController?
    var presentingAlert = false
    var fetchedResultsController: NSFetchedResultsController!
    
    
    // MARK: View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Messages"
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: WSColor.Green, NSFontAttributeName: WSFont.SueEllenFrancisco(26)]
        
        // Set up the fetch results controller
        initializeFetchedResultsController()
        
        // Set the refresh controller for the tableview
        initializeRefreshController()
        
        // Set up the message thread updater
        configureMessageThreadsUpdater()
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
            finishedUpdates()
        }
    }
    
    func configureMessageThreadsUpdater() {
        messageThreadUpdater = WSMessageThreadsUpdater(store: store)
        messageThreadUpdater.success = {
            self.lastUpdated = NSDate()
            self.updateAllMessages()
        }
        messageThreadUpdater.failure = { (error) -> Void in
            self.setFailedUpdateAlert(error)
            self.finishedUpdates()
        }
    }
    
    func initializeFetchedResultsController() {
        let request = NSFetchRequest(entityName: "MessageThread")
        let timeSort = NSSortDescriptor(key: "last_updated", ascending: false)
        request.sortDescriptors = [timeSort]
        
        let moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
    }
    
    func initializeRefreshController() {
        let refreshController = UIRefreshControl()
        refreshController.addTarget(self, action: Selector("update"), forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = refreshController
    }
    
    
    // MARK: Utility methods
    
    func update() {
        messageThreadUpdater.update()
    }
    
    func finishedUpdates() {
        
        // Hide any activity indicators
        self.refreshControl!.endRefreshing()
        WSProgressHUD.hide()
        
        // Update the tab bar badge
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            print("Reloading ...")
            do {
                try self.fetchedResultsController.performFetch()
                self.tableView.reloadData()
                self.updateTabBarBadge()
            } catch let error as NSError {
                self.setFailedUpdateAlert(error)
                self.showAlert()
            }
        }
        
        // Show any errors
        showAlert()
    }
    
    // Updates the messages on each thread if required
    //
    func updateAllMessages() {
        
        // Update the messages if necessary, or just reload if no updates are required
        do {
            let threadIDs = try store.messageThreadsThatNeedUpdating()
            print("updating threads: \(threadIDs)")
            if threadIDs.count > 0 {
                for threadID in threadIDs {
                    self.updateMessagesOnThread(threadID)
                }
            } else {
                finishedUpdates()
            }
        } catch let error as NSError {
            setFailedUpdateAlert(error)
            finishedUpdates()
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
        
        let messageUpdater = WSMessageUpdater(threadID: threadID, store: store)
        messageUpdater.success = {
            self.updateFinishedForThreadID(threadID)
        }
        messageUpdater.failure = { (error) -> Void in
//            self.cancelAllUpdates()
            self.setFailedUpdateAlert(error)
            self.updateFinishedForThreadID(threadID)
        }
        updatesInProgress[threadID] = messageUpdater
        print("starting update for thread: \(threadID)")
        messageUpdater.update()
    }

    // Removes the message updater object assign to a given thread and reloads the table if all updates are done
    //
    func updateFinishedForThreadID(threadID: Int) {
        
        // Remove the updater
        self.updatesInProgress.removeValueForKey(threadID)
        print("finished for \(threadID)")
        
        // Reload the table view if all the updates are finished
        if updatesInProgress.count == 0 {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.finishedUpdates()
            })
        }
    }
    
    // Update the tab bar badge with the number of unread threads
    //
    func updateTabBarBadge() {
        do {
            let unread = try store.numberOfUnreadMessageThreads()
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                if unread > 0 {
                    self.navigationController?.tabBarItem.badgeValue = String(unread)
                } else {
                    self.navigationController?.tabBarItem.badgeValue = nil
                }
            }
        } catch {
            // Take know action as the badge is not that important
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
        if identifier == MessageSegueID {
            if let cell = sender as? MessageThreadsTableViewCell {
                if cell.threadID != nil {
                    return true
                }
            }
        }
        return false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == MessageSegueID {
            
            let cell = sender as? MessageThreadsTableViewCell
            
            // Assign the message thread data to the destination view controller
            let messageThreadVC = segue.destinationViewController as! MessageThreadTableViewController
            messageThreadVC.threadID = cell?.threadID
        }
    }
    
}
