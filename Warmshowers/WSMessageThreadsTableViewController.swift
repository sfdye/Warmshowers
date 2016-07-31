//
//  WSMessageThreadsTableViewController.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 1/12/15.
//  Copyright © 2015 Rajan Fernandez. All rights reserved.
//

import UIKit
import CoreData
import ReachabilitySwift

class WSMessageThreadsTableViewController: UITableViewController {
    
    // MARK: Properties
    
    var lastUpdated: NSDate?
    var downloadsInProgress = Set<Int>()
    var errorCache: ErrorType?
    var fetchedResultsController: NSFetchedResultsController?
    let formatter = NSDateFormatter()
    
    var currentUserUID: Int? { return WSSessionState.sharedSessionState.uid }
    
    // Delegates
    var alert: WSAlertDelegate = WSAlertDelegate.sharedAlertDelegate
    var api: WSAPICommunicator = WSAPICommunicator.sharedAPICommunicator
    var store: WSStoreProtocol = WSStore.sharedStore
    var connection: WSReachabilityProtocol = WSReachabilityManager.sharedReachabilityManager
    
    // MARK: View life cycle
    
    deinit {
        connection.deregisterFromNotifications(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Navigation bar configuration.
        navigationItem.title = "Messages"
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: WSColor.Green, NSFontAttributeName: WSFont.SueEllenFrancisco(26)]
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: self, action: #selector(WSMessageThreadsTableViewController.update))
        
        // Set up the date formatter.
        let template = "dd/MM/yy"
        let locale = NSLocale.currentLocale()
        formatter.dateFormat = NSDateFormatter.dateFormatFromTemplate(template, options: 0, locale: locale)
        
        // Set the refresh controller for the tableview.
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(WSMessageThreadsTableViewController.update), forControlEvents: UIControlEvents.ValueChanged)
        
        // Set up the fetch results controller.
        initialiseFetchResultsController()
        
        // Reachability notifications
        connection.registerForAndStartNotifications(self, selector: #selector(WSMessageThreadsTableViewController.reachabilityChanged(_:)))
    }
    
    override func viewWillAppear(animated: Bool) {
        
        // Reset the navigation bar text properties
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: WSColor.Green, NSFontAttributeName: WSFont.SueEllenFrancisco(26)]
        
        if fetchedResultsController == nil {
            initialiseFetchResultsController()
        }
        
        showReachabilityBannerIfNeeded()
    }
    
    override func viewDidAppear(animated: Bool) {
        
        // Update the message threads on loading the view or if more than 10 minutes has elapsed
        guard let lastUpdated = lastUpdated where lastUpdated.timeIntervalSinceNow < 600 else {
            update()
            return
        }
        
        dispatch_async(dispatch_get_main_queue()) {  [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        // This prevents the fetch results controller from updating while the view is not visible.
        fetchedResultsController = nil
    }
    
    func initialiseFetchResultsController() {
        let request = NSFetchRequest(entityName: WSMOMessageThread.entityName)
        request.sortDescriptors = [NSSortDescriptor(key: "last_updated", ascending: false)]
        let moc = WSStore.sharedStore.managedObjectContext
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: moc,
            sectionNameKeyPath: nil,
            cacheName: nil)
        fetchedResultsController!.delegate = self
        do {
            try fetchedResultsController!.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
    }
    
    
    // MARK: Reachability
    
    func reachabilityChanged(note: NSNotification) {
        showReachabilityBannerIfNeeded()
    }
    
    func showReachabilityBannerIfNeeded() {
        if !connection.isOnline {
            alert.showNoInternetBanner()
        } else {
            alert.hideAllBanners()
        }
    }
    
    
    // MARK: Utility methods
    
    func update() {
        WSProgressHUD.show("Updating messages ...")
        api.contactEndPoint(.GetAllMessageThreads, withPathParameters: nil, andData: nil, thenNotify: self)
    }
    
    /** Called after and update once all API requests have responded. */
    func didFinishedUpdates() {
        
        // Hide any activity indicators
        dispatch_async(dispatch_get_main_queue()) { [weak self] () -> Void in
            self?.refreshControl?.endRefreshing()
            WSProgressHUD.hide()
            if let error = self?.errorCache {
                self?.alert.presentAPIError(error, forDelegator: self)
                self?.errorCache = nil
            }
            self?.lastUpdated = NSDate()
        }
    }
    
    /** Updates the messages on each thread if required. */
    func updateAllMessages() {
        
        // Update the messages if necessary, or just reload if no updates are required
        do {
            let messageThreads = try store.retrieve(WSMOMessageThread.self, sortBy: nil, isAscending: true, predicate: nil)
            
            var threadsNeedingUpdate = [WSMOMessageThread]()
            for thread in messageThreads {
                if thread.needsUpdating() {
                    threadsNeedingUpdate.append(thread)
                }
            }
            
            guard threadsNeedingUpdate.count > 0 else {
                didFinishedUpdates()
                return
            }
            
            for thread in threadsNeedingUpdate {
                guard let threadID = thread.thread_id else { continue }
                api.contactEndPoint(.GetMessageThread, withPathParameters: nil, andData: threadID, thenNotify: self)
                downloadsInProgress.insert(threadID)
            }
        } catch let error as NSError {
            alert.presentAlertFor(self, withTitle: "Error", button: "OK", message: error.localizedDescription)
        }
    }
    
    /** Updates the tab bar badge with the number of unread threads. */
    func updateTabBarBadge() {
        do {
            let messageThreads = try store.retrieve(WSMOMessageThread.self, sortBy: nil, isAscending: true, predicate: nil)
            
            var unread = 0
            for thread in messageThreads {
                if thread.is_new { unread += 1 }
            }

            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                if unread > 0 {
                    self.navigationController?.tabBarItem.badgeValue = String(unread)
                } else {
                    self.navigationController?.tabBarItem.badgeValue = nil
                }
            }
        } catch {
            // Not an important error. The badge will get updated next message thread update.
        }
    }
    
    func textForMessageThreadDate(date: NSDate?) -> String? {
        guard let date = date else { return "" }
        return formatter.stringFromDate(date)
    }
    
}
