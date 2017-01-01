//
//  MessageThreadTableViewController.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 3/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit
import CoreData
import WarmshowersData

let MessagesViewNeedsUpdateNotificationName = "ws_message_view_needs_update"

class MessageThreadTableViewController: UITableViewController, Delegator, DataSource {
    
    var threadID: Int?
    var fetchedResultsController: NSFetchedResultsController<MOMessage>!
    var downloadsInProgress = Set<String>()
    var alert: UIAlertController?
    let formatter = DateFormatter()
    
    
    // MARK: View life cycle
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
        let locale = Locale.current
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: template, options: 0, locale: locale)
        
        // Set the refresh controller for the tableview
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(MessageThreadTableViewController.update), for: UIControlEvents.valueChanged)
        
        // Set the view title
        navigationItem.title = subjectForMessageThreadWithID(threadID ?? 0)
        
        // Set up the fetch results controller
        initialiseFetchResultsController()
        
        // Mark the thread as read.
        markThread(threadID ?? 0, asRead: true)
        
        // Register for update notifications. This is fired after a reply is sent.
        let notificationCentre = NotificationCenter.default
        notificationCentre.addObserver(self, selector: #selector(MessageThreadTableViewController.update), name: NSNotification.Name(rawValue: MessagesViewNeedsUpdateNotificationName), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: WarmShowersColor.Green, NSFontAttributeName: WarmShowersFont.SueEllenFrancisco(18)]
        
        if fetchedResultsController == nil {
            initialiseFetchResultsController()
        }
        
        // Scroll to the bottom of the thread (i.e. the most recent message)
        let row = max(tableView.dataSource!.tableView(tableView, numberOfRowsInSection: 0) - 1, 0)
        let indexPath = IndexPath(row: row, section: 0)
        DispatchQueue.main.async { [unowned self] in
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadImagesForObjectsOnScreen()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        // This prevents the fetch results controller from updating while the view is not visible.
        fetchedResultsController = nil
    }
    
    func initialiseFetchResultsController() {
        let request = MOMessage.fetchRequest() as! NSFetchRequest<MOMessage>
        request.predicate = NSPredicate(format: "thread.p_thread_id==%i", threadID ?? 0)
        request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: true)]
        self.fetchedResultsController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: store.managedObjectContext,
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
    
    /** Returns the subject of a message thread given the thread ID. */
    func subjectForMessageThreadWithID(_ threadID: Int) -> String? {
        let predicate = NSPredicate(format: "p_thread_id == %d", threadID)
        guard let thread: MOMessageThread = try! store.retrieve(inContext: store.managedObjectContext, withPredicate: predicate, andSortBy: nil, isAscending: true).first
            else {
            return nil
        }
        return thread.subject
    }
    
    /** Updates the messages. */
    func update() {
        guard let threadID = threadID else { return }
        api.contact(endPoint: .messageThread, withMethod: .post, andPathParameters: nil, andData: threadID, thenNotify: self)
    }
    
    /** Mark message thread as read. */
    func markThread(_ threadID: Int, asRead read: Bool) {
        let readState = MessageThreadReadState(threadID: threadID, read: true)
        api.contact(endPoint: .markThreadRead, withMethod: .post, andPathParameters: nil, andData: readState, thenNotify: self)
    }
    
    func startImageDownloadForIndexPath(_ indexPath: IndexPath) {
        let message = self.fetchedResultsController.object(at: indexPath)
        guard message.author?.image == nil else { return }
        if let url = message.author?.image_url {
            api.contact(endPoint: .imageResource, withMethod: .get, andPathParameters: url, andData: nil, thenNotify: self)
        } else if let uid = message.author?.uid , !downloadsInProgress.contains(String(uid)) {
            // We first need to get the image URL from the authors profile.
            downloadsInProgress.insert(String(uid))
            api.contact(endPoint: .user, withMethod: .get, andPathParameters: String(uid), andData: nil, thenNotify: self)
        }
    }
    
    func loadImagesForObjectsOnScreen() {
        guard let visiblePaths = tableView.indexPathsForVisibleRows else { return }
        for indexPath in visiblePaths {
            startImageDownloadForIndexPath(indexPath)
        }
    }
    
    /** Sets the image for a host in the list with the given image URL. */
    func setImage(_ image: UIImage, forHostWithImageURL imageURL: String) {
        
        let predicate = NSPredicate(format: "image_url LIKE %@", imageURL)
        
        guard let participant: MOUser = try! store.retrieve(inContext: store.managedObjectContext, withPredicate: predicate, andSortBy: nil, isAscending: true).first else {
            return
        }
        
        participant.image = image
        try! store.managedObjectContext.save()
        
        // Set the image in any message table view cells where the user in the author.
        DispatchQueue.main.async { [unowned self] in
            guard let visiblePaths = self.tableView.indexPathsForVisibleRows else { return }
            for indexPath in visiblePaths {
                if let cell = self.tableView.cellForRow(at: indexPath) as? MessageTableViewCell {
                    let message = self.fetchedResultsController.object(at: indexPath)
                    if let url = message.author?.image_url, url == imageURL {
                        cell.authorImageView.image = image
                    }
                }
            }
        }
    }
    
    func textForMessageDate(_ date: Date?) -> String? {
        guard let date = date else { return "" }
        return formatter.string(from: date)
    }
    
}
