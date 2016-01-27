//
//  MessageThreadTableViewController.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 3/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit
import CoreData

let MESSAGE_FROM_USER_CELL_ID = "MessageFromUser"
let MESSAGE_FROM_SELF_CELL_ID = "MessageFromSelf"

let REPLY_TO_MESSAGE_SEGUE_ID = "ToReplyToMessage"

class MessageThreadTableViewController: UITableViewController {
    
    var threadID: Int? = nil
    var messageThread: CDWSMessageThread?
    var messages = [CDWSMessage]()

    let moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var updater: WSMessageThreadUpdater!
    var queue = NSOperationQueue()
    var refreshController = UIRefreshControl()
    
    var currentUserUID: Int? {
        let defaults = NSUserDefaults.standardUserDefaults()
        return defaults.integerForKey(defaults_key_uid)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view title
        navigationItem.title = messageThread?.subject
        
        // Force the back button to plain style
        // TODO
        
        // Configure the table view
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 104
        
        // Update the table view data source
        updateDataSource()
        tableView.reloadData()
        
        // Configure the updater
        updater = WSMessageThreadUpdater(messageThread: messageThread!, queue: queue)
        updater.success = {
            self.updateDataSource()
            self.refreshControl!.endRefreshing()
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView.reloadData()
            })
        }
        updater.failure = {
            self.refreshControl!.endRefreshing()
            print(self.updater.error)
        }
        
        // Configure the refresh controller
        // Set the refresh controller for the tableview
        let refreshController = UIRefreshControl()
        refreshController.addTarget(self, action: Selector("updateMessages"), forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = refreshController
        
        // Update the model
        updateAuthorImages()
        markAsRead()
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: WSColor.Green, NSFontAttributeName: WSFont.SueEllenFrancisco(18)]
    }
    
    func updateDataSource() {
        // Get the messages and sort them by date
        messages = messageThread?.messages?.allObjects as! [CDWSMessage]
        messages.sortInPlace({
            return $0.timestamp!.laterDate($1.timestamp!).isEqualToDate($1.timestamp!)
        })
    }

    
    // MARK: Navigation
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if identifier == REPLY_TO_MESSAGE_SEGUE_ID {
            return messageThread != nil
        }
        return false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == REPLY_TO_MESSAGE_SEGUE_ID {
            let navVC = segue.destinationViewController as! UINavigationController
            let composeMessageVC = navVC.viewControllers.first as! ComposeMessageViewController
            composeMessageVC.initialiseAsReplyOnMessageThread(messageThread!)
        }
    }
    
    
    // MARK: Utility methods
    
    // Updates all the author thumbnails
    //
    func updateAuthorImages() {
        
        let authors = messageThread?.participants?.allObjects as! [CDWSUser]
        
        for author in authors {
            if author.image == nil {
                
                let uid = author.uid!.integerValue
                
                WSRequest.getUserThumbnailImage(uid, doWithImage: { (image) -> Void in
                    if let image = image {
                        author.image = image
                        do {
                            try self.moc.save()
                            self.reloadMessagesWithAuthorUID(uid)
                        } catch {
                            print("Error saving user thumbnail to store.")
                        }
                    }
                })
            }
        }
    }
    
    // Reloads rows in the table view by author uid
    //
    func reloadMessagesWithAuthorUID(uid: Int) {
        
        guard messages.count > 0 else {
            return
        }
        
        var indexPaths = [NSIndexPath]()
        
        for (index, message) in messages.enumerate() {
            if message.author!.uid!.integerValue == uid {
                indexPaths.append(NSIndexPath(forRow: index, inSection: 0))
            }
        }
        
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.tableView.reloadRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
        }
    }
    
    // Mark message thread as read
    func markAsRead() {
        
        guard let threadID = messageThread?.thread_id!.integerValue else {
            return
        }
        
        WSRequest.markMessageThread(threadID) { (data) -> Void in
            
            // On success update the local model
            self.messageThread?.is_new = false
            do {
                try self.moc.save()
            } catch {
                print("failed")
            }
        }
    }
    
    func updateMessages() {
        
        // Clear the messages from the context
        messages = [CDWSMessage]()
        
        // Update the thread
        updater.error = nil
        updater.tokenGetter.start()
    }
    
}
