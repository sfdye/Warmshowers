//
//  WSMessageThreadsTableViewController.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 1/12/15.
//  Copyright © 2015 Rajan Fernandez. All rights reserved.
//

import UIKit
import CoreData
import MBProgressHUD
import ReachabilitySwift

class WSMessageThreadsTableViewController: UITableViewController {
    
    // MARK: Properties
    
    var messageThreadUpdater: WSMessageThreadsUpdater!
    var lastUpdated: NSDate?
    var updatesInProgress = [Int: WSMessageUpdater]()
    var alert: UIAlertController?
    var presentingAlert = false
    var fetchedResultsController: NSFetchedResultsController!
    
    // Delegates
    var alertDelegate: WSAlertProtocol = WSAlertDelegate.sharedAlertDelegate
    let store: WSStoreMessageThreadProtocol = WSStore.sharedStore
    var connection: WSReachabilityProtocol = WSReachabilityManager.sharedReachabilityManager
    
    // MARK: View life cycle
    
    deinit {
        connection.deregisterFromNotifications(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Messages"
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: WSColor.Green, NSFontAttributeName: WSFont.SueEllenFrancisco(26)]
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: self, action: #selector(WSMessageThreadsTableViewController.update))
        
        // Set up the fetch results controller
        initializeFetchedResultsController()
        
        // Set the refresh controller for the tableview
        initializeRefreshController()
        
        // Set up the message thread updater
        configureMessageThreadsUpdater()
        
        // Table view autolayout options
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 96
        
        // Reachability notifications
        connection.registerForAndStartNotifications(self, selector: #selector(WSMessageThreadsTableViewController.reachabilityChanged(_:)))
    }
    
    override func viewWillAppear(animated: Bool) {
        
        // Reset the navigation bar text properties
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: WSColor.Green, NSFontAttributeName: WSFont.SueEllenFrancisco(26)]
        
        showReachabilityBannerIfNeeded()
    }
    
    override func viewDidAppear(animated: Bool) {
        
        // Update the message threads on loading the view or if more than 10 minutes has elapsed
        if let lastUpdated = lastUpdated where lastUpdated.timeIntervalSinceNow < 600 {
            finishedUpdates()
        } else {
            update()
        }
    }
    
    func configureMessageThreadsUpdater() {
        messageThreadUpdater = WSMessageThreadsUpdater(
            success: {
                self.lastUpdated = NSDate()
                self.updateAllMessages()
            },
            failure: { (error) -> Void in
                self.setErrorAlert(error)
                self.finishedUpdates()
        })
    }
    
    func initializeFetchedResultsController() {
        let request = NSFetchRequest(entityName: WSEntity.Thread.rawValue)
        request.sortDescriptors = [NSSortDescriptor(key: "last_updated", ascending: false)]
        let moc = WSStore.sharedStore.managedObjectContext
        self.fetchedResultsController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: moc,
            sectionNameKeyPath: nil,
            cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
    }
    
    func initializeRefreshController() {
        let refreshController = UIRefreshControl()
        refreshController.addTarget(self, action: #selector(WSMessageThreadsTableViewController.update), forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = refreshController
    }
    
    
    // MARK: Reachability
    
    func reachabilityChanged(note: NSNotification) {
        showReachabilityBannerIfNeeded()
    }
    
    func showReachabilityBannerIfNeeded() {
        if !connection.isOnline {
            alertDelegate.showNoInternetBanner()
        } else {
            alertDelegate.hideAllBanners()
        }
    }
    
    
    // MARK: Utility methods
    
    func update() {
        
        guard connection.isOnline else {
            refreshControl?.endRefreshing()
            return
        }
        
        if lastUpdated == nil {
            WSProgressHUD.show("Updating messages ...")
        }
        messageThreadUpdater.update()
    }
    
    // Updates the table view and shows sny error alerts
    //
    func finishedUpdates() {
        
        // Hide any activity indecators
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.refreshControl!.endRefreshing()
            WSProgressHUD.hide()
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
            if threadIDs.count > 0 {
                for threadID in threadIDs {
                    self.updateMessagesOnThread(threadID)
                }
            } else {
                finishedUpdates()
            }
        } catch let error as NSError {
            setErrorAlert(error)
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
        
        guard connection.isOnline else {
            self.updateFinishedForThreadID(threadID)
            return
        }
        
        guard updatesInProgress[threadID] == nil else {
            return
        }
        
        let messageUpdater = WSMessageUpdater(
            threadID: threadID,
            success: {
                self.updateFinishedForThreadID(threadID)
            },
            failure: { (error) -> Void in
                self.setErrorAlert(error)
                self.updateFinishedForThreadID(threadID)
            }
        )
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
            self.finishedUpdates()
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
    func setErrorAlert(error: NSError? = nil) {
        
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
            // Assign the message thread data to the destination view controller
            let messageThreadVC = segue.destinationViewController as! WSMessageThreadTableViewController
            messageThreadVC.threadID = (sender as? MessageThreadsTableViewCell)?.threadID
        }
    }
    
}
