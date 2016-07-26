//
//  WSMessageThreadTableViewController.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 3/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit
import CoreData

class WSMessageThreadTableViewController: UITableViewController {
    
    var threadID: Int?
    var fetchedResultsController: NSFetchedResultsController!
    var downloadsInProgress = Set<String>()
    var alert: UIAlertController?
    let formatter = NSDateFormatter()
    
    // Delegates
    let store: protocol<WSStoreMessageThreadProtocol, WSStoreParticipantProtocol>  = WSStore.sharedStore
    let session: WSSessionStateProtocol = WSSessionState.sharedSessionState
    var api: WSAPICommunicatorProtocol = WSAPICommunicator.sharedAPICommunicator
    
    
    // MARK: View life cycle
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view title
        navigationItem.title = ""
        
        // Configure the table view
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 104
        
        // Set up the date formatter.
        let template = "HHmmddMMMyyyy"
        let locale = NSLocale.currentLocale()
        formatter.dateFormat = NSDateFormatter.dateFormatFromTemplate(template, options: 0, locale: locale)
        
        // Set the refresh controller for the tableview
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(WSMessageThreadTableViewController.update), forControlEvents: UIControlEvents.ValueChanged)
        
        // Set the view title
        navigationItem.title = store.subjectForMessageThreadWithID(threadID ?? 0)
        
        // Set up the fetch results controller
        initialiseFetchResultsController()
        
        // Mark the thread as read.
        markThread(threadID ?? 0, asRead: true)
        
        // Register for update notifications. This is fired after a reply is sent.
        let notificationCentre = NSNotificationCenter.defaultCenter()
        notificationCentre.addObserver(self, selector: #selector(WSMessageThreadTableViewController.update), name: MessagesViewNeedsUpdateNotificationName, object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: WSColor.Green, NSFontAttributeName: WSFont.SueEllenFrancisco(18)]
        
        if fetchedResultsController == nil {
            initialiseFetchResultsController()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        loadImagesForObjectsOnScreen()
    }
    
    override func viewDidDisappear(animated: Bool) {
        // This prevents the fetch results controller from updating while the view is not visible.
        fetchedResultsController = nil
    }
    
    func initialiseFetchResultsController() {
        let request = NSFetchRequest(entityName: "Message")
        request.predicate = NSPredicate(format: "thread.thread_id==%i", threadID ?? 0)
        request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: true)]
        self.fetchedResultsController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: WSStore.sharedStore.managedObjectContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        fetchedResultsController.delegate = self
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
    }
    

    // MARK: Utilities
    
    /** Updates the messages. */
    func update() {
        guard let threadID = threadID else { return }
        api.contactEndPoint(.GetMessageThread, withPathParameters: nil, andData: threadID, thenNotify: self)
    }
    
    /** Mark message thread as read. */
    func markThread(threadID: Int, asRead read: Bool) {
        let readState = WSMessageThreadReadState(threadID: threadID, read: true)
        api.contactEndPoint(.MarkThreadRead, withPathParameters: nil, andData: readState, thenNotify: self)
    }
    
    func startImageDownloadForIndexPath(indexPath: NSIndexPath) {
        guard let message = self.fetchedResultsController.objectAtIndexPath(indexPath) as? CDWSMessage else { return }
        guard message.author?.image == nil else { return }
        if let url = message.author?.image_url {
            api.contactEndPoint(.ImageResource, withPathParameters: url as NSString, andData: nil, thenNotify: self)
        } else if let uid = message.author?.uid where !downloadsInProgress.contains(String(uid)) {
            // We first need to get the image URL from the authors profile.
            downloadsInProgress.insert(String(uid))
            api.contactEndPoint(.UserInfo, withPathParameters: String(uid) as NSString, andData: nil, thenNotify: self)
        }
    }
    
    func loadImagesForObjectsOnScreen() {
        guard let visiblePaths = tableView.indexPathsForVisibleRows else { return }
        for indexPath in visiblePaths {
            startImageDownloadForIndexPath(indexPath)
        }
    }
    
    /** Sets the image for a host in the list with the given image URL. */
    func setImage(image: UIImage, forHostWithImageURL imageURL: String) {
        store.updateParticipantWithImageURL(imageURL, withImage: image)
        dispatch_async(dispatch_get_main_queue()) { [weak self] in
            guard let visiblePaths = self?.tableView.indexPathsForVisibleRows else { return }
            for indexPath in visiblePaths {
                if
                    let cell = self?.tableView.cellForRowAtIndexPath(indexPath) as? MessageTableViewCell,
                    let message = self?.fetchedResultsController.objectAtIndexPath(indexPath) as? CDWSMessage,
                    let url = message.author?.image_url
                    where url == imageURL
                {
                    cell.authorImageView.image = image
                }
            }
        }
    }
    
    func textForMessageDate(date: NSDate?) -> String? {
        guard let date = date else { return "" }
        return formatter.stringFromDate(date)
    }
    
}
