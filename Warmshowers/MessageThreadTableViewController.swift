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
    var authors = [CDWSUser]()

    let moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var currentUserUID: Int? {
        let defaults = NSUserDefaults.standardUserDefaults()
        return defaults.integerForKey(defaults_key_uid)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view title
        navigationItem.title = messageThread?.subject
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: WSColor.DarkBlue,
            NSFontAttributeName: WSFont.SueEllenFrancisco(18)]
        
        // Force the back button to plain style
        // TODO
        
        // Configure the table view
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 104
        
        // Update the model
        updateAuthorImages()
        markAsRead()
    }
    
    
    // MARK: - Tableview Data Source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let message = messages[indexPath.row]
        
        let cellID = (message.author!.uid == currentUserUID) ? MESSAGE_FROM_SELF_CELL_ID : MESSAGE_FROM_USER_CELL_ID
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as! MessageTableViewCell
        cell.configureWithMessage(self.messages[indexPath.row])
        
        return cell
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
    
}
