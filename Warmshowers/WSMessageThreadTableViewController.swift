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
    var refreshController = UIRefreshControl()
    var fetchedResultsController: NSFetchedResultsController!
    var alert: UIAlertController?
    let formatter = NSDateFormatter()
    
    // Delegates
    let store: WSStoreMessageThreadProtocol = WSStore.sharedStore
    let session: WSSessionStateProtocol = WSSessionState.sharedSessionState
    var api: WSAPICommunicatorProtocol = WSAPICommunicator.sharedAPICommunicator
    
    
    // MARK: View life cycle
    
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
        let refreshController = UIRefreshControl()
        refreshController.addTarget(self, action: #selector(WSMessageThreadTableViewController.update), forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = refreshController
        
        // Set the view title
        navigationItem.title = store.subjectForMessageThreadWithID(threadID ?? 0)
        
        // Set up the fetch results controller
        let request = NSFetchRequest(entityName: "Message")
        request.predicate = NSPredicate(format: "thread.thread_id==%i", threadID ?? 0)
        request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: true)]
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: WSStore.sharedStore.privateContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
        
        // Mark the thread as read.
        markThread(threadID ?? 0, asRead: true)
        
        // Register for update notifications. This is fired after a reply is sent.
//        let notificationCentre = NSNotificationCenter.defaultCenter()
//        notificationCentre.addObserver(self, selector: #selector(WSMessageThreadTableViewController.update), name: MessagesViewNeedsUpdateNotificationName, object: nil)
        
//        // Reload the table
//        self.reload(true)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: WSColor.Green, NSFontAttributeName: WSFont.SueEllenFrancisco(18)]
    }
    

    // MARK: Utilities
    
    /** Updates the messages. */
    func update() {
        // UPDATE CODE HERE
    }
    
    /** Mark message thread as read. */
    func markThread(threadID: Int, asRead read: Bool) {
        
        guard
            let storedThread = try? store.messageThreadWithID(threadID),
            let thread = storedThread,
            let threadID = thread.thread_id?.integerValue
            else { return }
        
        let readState = WSMessageThreadReadState(threadID: threadID, read: true)
        api.contactEndPoint(.MarkThreadRead, withPathParameters: nil, andData: readState, thenNotify: self)
    }
    
//    /** Reloads the tableview and hides any activity indicators. */
//    func reload(scroll: Bool = false) {
//        
//        // Hide any activity indicators and reload the tableview
//        dispatch_async(dispatch_get_main_queue(), { () -> Void in
//            self.refreshControl!.endRefreshing()
//            do {
//                try self.fetchedResultsController.performFetch()
//                self.tableView.reloadData()
//                if scroll {
//                    let row = self.tableView.numberOfRowsInSection(0) - 1
//                    let indexPath = NSIndexPath(forRow: row, inSection: 0)
//                    self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Bottom, animated: true)
//                }
//            } catch {
//                // If there is a problem fetching suggest that the user reinstall the app
//                self.alert = UIAlertController(title: "There was a problem loading your messages.", message: "Please try uninstalling and reinstalling the app and report this issue.", preferredStyle: .Alert)
//                let okAction = UIAlertAction(title: "Dismiss", style: .Default, handler: nil)
//                self.alert!.addAction(okAction)
//            }
//        })
//    }
    
//    // Updates all the author thumbnails
//    //
//    func updateAuthorImages() {
//        
//        do {
//            let messageThread = try store.messageThreadWithID(threadID)
//            let authors = messageThread?.participants?.allObjects as! [CDWSUser]
//            for author in authors {
//                if author.image == nil {
//                    
//                    let uid = author.uid!.integerValue
//                    
////                    WSRequest.getUserThumbnailImage(uid, doWithImage: { (image) -> Void in
////                        
////                        guard let image = image else {
////                            return
////                        }
////                        
////                        do {
////                            // TODO: This should be refactored so that the store remains as a delegate variable
////                            try WSStore.sharedStore.updateParticipant(uid, withImage: image)
////                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
////                                self.reloadImage(image, forAuthor: uid)
////                            })
////                        } catch {
////                            // Not a big deal if the thumbnails don't load
////                        }
////                    })
//                }
//            }
//        } catch {
//            // Not a big deal if the thumbnails don't load
//        }
//    }

//    // Reloads thumbnails in the tableview for a given user
//    //
//    func reloadImage(image: UIImage, forAuthor uid: Int) {
//        
//        let numberOfRows = tableView.numberOfRowsInSection(0)
//        for row in 0...numberOfRows - 1 {
//            let indexPath = NSIndexPath(forRow: row, inSection: 0)
//            let message = self.fetchedResultsController.objectAtIndexPath(indexPath) as! CDWSMessage
//            if message.author?.uid == uid {
//                if let cell = self.tableView.cellForRowAtIndexPath(indexPath) as? MessageTableViewCell {
//                    cell.authorImageView.image = image
//                }
//            }
//        }
//    }
    
//    // Sets an failed update alert to be displayed at the end of the updates
//    //
//    func setErrorAlert(error: NSError? = nil) {
//        
//        guard alert == nil else {
//            return
//        }
//        
//        if !presentingAlert {
//            var message: String = "Please check that you are connected to the internet and try again."
//            if let error = error {
//                message = error.localizedDescription
//            }
//            let alert = UIAlertController(title: "Failed to update messages", message: message, preferredStyle: .Alert)
//            let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
//            alert.addAction(okAction)
//            self.alert = alert
//        }
//    }
    
//    // Presents any alerts set during message updates
//    //
//    func showAlert() {
//        
//        guard let alert = alert else {
//            return
//        }
//        
//        if !presentingAlert {
//            presentingAlert = true
//            dispatch_async(dispatch_get_main_queue(), {
//                self.presentViewController(alert, animated: true, completion: { () -> Void in
//                    self.alert = nil
//                    self.presentingAlert = false
//                })
//            })
//        }
//    }
    
    func textForMessageDate(date: NSDate?) -> String? {
        guard let date = date else { return "" }
        return formatter.stringFromDate(date)
    }
    
}
