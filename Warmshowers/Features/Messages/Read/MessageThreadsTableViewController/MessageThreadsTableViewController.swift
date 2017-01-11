//
//  MessageThreadsTableViewController.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 1/12/15.
//  Copyright © 2015 Rajan Fernandez. All rights reserved.
//

import UIKit
import CoreData
import WarmshowersData

class MessageThreadsTableViewController: UITableViewController, Delegator, DataSource {
    
    // MARK: Properties
    
    var lastUpdated: Date?
    var downloadsInProgress = Set<Int>()
    var errorCache: Error?
    var fetchedResultsController: NSFetchedResultsController<MOMessageThread>?
    let formatter = DateFormatter()
    
    var currentUserUID: Int? { return session.uid }
    
    var needsUpdate: Bool = false
    
    
    // MARK: View life cycle
    
    deinit {
        api.connection.deregisterFromNotifications(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Navigation bar configuration.
        navigationItem.title = "Messages"
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: WarmShowersColor.Green, NSFontAttributeName: WarmShowersFont.SueEllenFrancisco(26)]
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(MessageThreadsTableViewController.update))
        
        // Set up the date formatter.
        let template = "dd/MM/yy"
        let locale = Locale.current
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: template, options: 0, locale: locale)
        
        // Set the refresh controller for the tableview.
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(MessageThreadsTableViewController.update), for: UIControlEvents.valueChanged)
        
        // Set up the fetch results controller.
        initialiseFetchResultsControllerWithStore(store)
        
        // Reachability notifications
        api.connection.registerForAndStartNotifications(self, selector: #selector(MessageThreadsTableViewController.reachabilityChanged(_:)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // Reset the navigation bar text properties
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: WarmShowersColor.Green, NSFontAttributeName: WarmShowersFont.SueEllenFrancisco(26)]
        
        if fetchedResultsController == nil {
            initialiseFetchResultsControllerWithStore(store)
        }
        
        showReachabilityBannerIfNeeded()
        
        if needsUpdate {
            DispatchQueue.main.async { [unowned self] in
                self.refreshControl?.beginRefreshing()
            }
            update()
            needsUpdate = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // Update the message threads on loading the view or if more than 1 hour has elapsed
        guard let lastUpdated = lastUpdated , lastUpdated.timeIntervalSinceNow < 6000 else {
            update()
            return
        }
        
        DispatchQueue.main.async {  [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        // This prevents the fetch results controller from updating while the view is not visible.
        fetchedResultsController = nil
    }
    
    func initialiseFetchResultsControllerWithStore(_ store: StoreDelegate) {
        let request: NSFetchRequest<MOMessageThread> = NSFetchRequest(entityName: MOMessageThread.entityName)
        request.sortDescriptors = [
            NSSortDescriptor(key: "last_updated", ascending: false)
        ]
        let moc = store.managedObjectContext
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
    
    func reachabilityChanged(_ note: Notification) {
        showReachabilityBannerIfNeeded()
    }
    
    func showReachabilityBannerIfNeeded() {
        if !api.connection.isOnline {
            alert.showNoInternetBanner()
        } else {
            alert.hideAllBanners()
        }
    }
    
    
    // MARK: Utility methods
    
    func update() {
        api.contact(endPoint: .messageThreads, withMethod: .post, andPathParameters: nil, andData: nil, thenNotify: self, ignoreCache: false)
    }
    
    /** Called after and update once all API requests have responded. */
    func didFinishedUpdates() {
        
        // Hide any activity indicators
        DispatchQueue.main.async { [unowned self] () -> Void in
            self.refreshControl?.endRefreshing()
            if let error = self.errorCache {
                self.alert.presentAPIError(error, forDelegator: self)
                self.errorCache = nil
            }
            self.lastUpdated = Date()
            self.tableView.reloadData()
        }
    }
    
    /** Updates the messages on each thread if required. */
    func updateAllMessages() {
        
        // Update the messages if necessary, or just reload if no updates are required
        do {
            let messageThreads: [MOMessageThread] = try store.retrieve(inContext: store.managedObjectContext, withPredicate: nil, andSortBy: nil, isAscending: true)
            
            var threadsNeedingUpdate = [MOMessageThread]()
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
                api.contact(endPoint: .messageThread, withMethod: .post, andPathParameters: nil, andData: threadID, thenNotify: self, ignoreCache: false)
                downloadsInProgress.insert(threadID)
            }
        } catch let error as NSError {
            alert.presentAlertFor(self, withTitle: "Error", button: "OK", message: error.localizedDescription)
        }
    }
    
    /** Updates the tab bar badge with the number of unread threads. */
    func updateTabBarBadge() {
        do {
            let messageThreads: [MOMessageThread] = try store.retrieve(inContext: store.managedObjectContext, withPredicate: nil, andSortBy: nil, isAscending: true)
            
            var unread = 0
            for thread in messageThreads {
                if thread.is_new { unread += 1 }
            }

            DispatchQueue.main.async { () -> Void in
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
    
    func textForMessageThreadDate(_ date: Date?) -> String? {
        guard let date = date else { return "" }
        return formatter.string(from: date)
    }
    
}
