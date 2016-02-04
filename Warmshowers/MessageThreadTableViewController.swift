//
//  MessageThreadTableViewController.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 3/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit
import CoreData

let MessageFromUserCellID = "MessageFromUser"
let MessageFromSelfCellID = "MessageFromSelf"

let ReplyToMessageThreadSegueID = "ToReplyToMessage"

class MessageThreadTableViewController: UITableViewController {
    
    var threadID: Int!

    lazy var messageUpdater: WSMessageUpdater = {
        let messageUpdater = WSMessageUpdater(threadID: self.threadID, store: self.store)
        messageUpdater.success = {
            self.reload()
        }
        messageUpdater.failure = { (error) -> Void in
            // Reload and show an error alert
            self.setErrorAlert(error)
            self.reload()
        }
        return messageUpdater
    }()
    let store = (UIApplication.sharedApplication().delegate as! AppDelegate).store
    var refreshController = UIRefreshControl()
    var fetchedResultsController: NSFetchedResultsController!
    var alert: UIAlertController?
    var presentingAlert = false
    
    var currentUserUID: Int? {
        let defaults = NSUserDefaults.standardUserDefaults()
        return defaults.integerForKey(defaults_key_uid)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view title
        navigationItem.title = store.subjectForMessageThreadWithID(threadID)
        
        // Configure the table view
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 104
        
        // Set up the fetch results controller
        initializeFetchedResultsController()
        
        // Set the refresh controller for the tableview
        initializeRefreshController()

        // Update the model
        updateAuthorImages()
        markAsRead()
        
        // Reload the table
        self.reload()
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: WSColor.Green, NSFontAttributeName: WSFont.SueEllenFrancisco(18)]
    }
    
    func initializeFetchedResultsController() {
        
        guard let threadID = threadID else {
            return
        }
        
        let request = NSFetchRequest(entityName: "Message")
        request.predicate = NSPredicate(format: "thread.thread_id==%i", threadID)
        request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
        
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: store.privateContext, sectionNameKeyPath: nil, cacheName: nil)
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
    
    // Updates the messages
    //
    func update() {
        messageUpdater.update()
    }
    
    // Reloads the tableview and hides any activity indicators
    //
    func reload() {
        
        // Hide any activity indicators and reload the tableview
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.refreshControl!.endRefreshing()
            do {
                try self.fetchedResultsController.performFetch()
                self.tableView.reloadData()
            } catch {
                // If there is a problem fetching suggest that the user reinstall the app
                self.alert = UIAlertController(title: "There was a problem loading your messages.", message: "Please try uninstalling and reinstalling the app and report this issue.", preferredStyle: .Alert)
                let okAction = UIAlertAction(title: "Dismiss", style: .Default, handler: nil)
                self.alert!.addAction(okAction)
            }
        })
        
        // Show errors
        showAlert()
    }
    
    
    // MARK: Navigation
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if identifier == ReplyToMessageThreadSegueID {
            return threadID != nil
        }
        return false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == ReplyToMessageThreadSegueID {
            let navVC = segue.destinationViewController as! UINavigationController
            let composeMessageVC = navVC.viewControllers.first as! ComposeMessageViewController
            composeMessageVC.initialiseAsReply(threadID)
        }
    }
    
    
    // MARK: Utility methods
    
    // Updates all the author thumbnails
    //
    func updateAuthorImages() {
        
        do {
            let messageThread = try store.messageThreadWithID(threadID)
            let authors = messageThread?.participants?.allObjects as! [CDWSUser]
            for author in authors {
                if author.image == nil {
                    
                    let uid = author.uid!.integerValue
                    
                    WSRequest.getUserThumbnailImage(uid, doWithImage: { (image) -> Void in
                        
                        do {
                            try self.store.updateUser(uid, withImage: image!)
                            self.reloadMessagesWithAuthorUID(uid)
                        } catch {
                            // Not a big deal if the thumbnails don't load
                        }
                    })
                }
            }
        } catch {
            // Not a big deal if the thumbnails don't load
        }
    }

    // Reloads rows in the table view by author uid
    //
    func reloadMessagesWithAuthorUID(uid: Int) {
        
        let numberOfRows = tableView.numberOfRowsInSection(0)
        var indexPaths = [NSIndexPath]()
        for row in 0...numberOfRows - 1 {
            let indexPath = NSIndexPath(forRow: row, inSection: 0)
            let message = self.fetchedResultsController.objectAtIndexPath(indexPath) as! CDWSMessage
            if message.author!.uid == uid {
                indexPaths.append(indexPath)
            }
        }

        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            do {
                try self.fetchedResultsController.performFetch()
                self.tableView.reloadRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
            } catch {
                // Not a big deal if the thumbnail doesn't load
            }
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
    
    // Mark message thread as read
    func markAsRead() {

        WSRequest.markMessageThread(threadID) { (data) -> Void in
            
            // On success update the local model
            do {
                try self.store.markMessageThreadAsRead(self.threadID)
            } catch {
                // This is not an important error
            }
        }
    }
    
}
