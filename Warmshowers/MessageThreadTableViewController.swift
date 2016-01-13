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
    var messageThread: CDWSMessageThread? = nil
    var messages = [CDWSMessage]()
    var authors = [CDWSUser]()
    
    let moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var currentUserUID: Int? {
        let defaults = NSUserDefaults.standardUserDefaults()
        return defaults.integerForKey(DEFAULTS_KEY_UID)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let threadID = threadID else {
            return
        }
        
        // Insert the message thread in the context
        let request = NSFetchRequest(entityName: "CDWSMessageThread")
        request.predicate = NSPredicate(format: "thread_id == %i", threadID)
        do {
            if let threads = try moc.executeFetchRequest(request) as? [CDWSMessageThread] {
                messageThread = threads.first
            }
        } catch {
            print("Could not get the message thread from the store")
        }
        
        // Set the view title
        navigationItem.title = messageThread?.subject
        
        // Configure the table view
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 104
    }
    
    override func viewDidAppear(animated: Bool) {
        
        // Update the data source
        update()
    }
    
    
    // MARK: - Tableview Data Source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if messages.count == 0 {
            return 0
        } else {
            return 1
        }
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
            if messages.count != 0 {
                return true
            }
        }
        return false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == REPLY_TO_MESSAGE_SEGUE_ID {
            let navVC = segue.destinationViewController as! UINavigationController
            let composeMessageVC = navVC.viewControllers.first as! ComposeMessageTableViewController
            composeMessageVC.initialiseAsReplyToMessage(messages.last!)
        }
    }
    
    
    // MARK: Utility methods
    
    // Downloads the messages, updates the store and the table view data source
    //
    func update() {
        
        guard let threadID = threadID else {
            return
        }
        
        WSRequest.getMessageThread(threadID, withMessageThreadData: { (data) -> Void in
            let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
            dispatch_async(queue, { () -> Void in
                self.updateDataSourceWithData(data)
                self.reload()
                self.updateAuthorImages()
            })
        })
    }
    
    func updateDataSourceWithData(data: NSData?) {
        
        guard let data = data else {
            return
        }
        
        // Clear the data source
        messages = [CDWSMessage]()
        authors = [CDWSUser]()
        
        // Parse the json
        if let json = WSRequest.jsonDataToJSONObject(data) {
            if let messagesJSON = json.valueForKey("messages") as? NSArray {
                for messageJSON in messagesJSON {
                    do {
                        let message = try messageWithJSON(messageJSON)
                        addMessageToDataSource(message)
                        addAuthorToDataSource(message.author!)
                    } catch DataError.InvalidInput {
                        print("Failed to save message due to invalid input")
                    } catch CoreDataError.FailedFetchReqeust {
                        print("Failed to save message due to a failed Core Data fetch request")
                    } catch {
                        print("Failed to create message participant for an unknown error")
                    }
                }
            }
        }
        
        // Save the context and reload the table view
        do {
            try moc.save()
        } catch {
            print("Could not save MOC.")
        }
        
        // Sort the data source messages
        messages.sortInPlace {
            return ($0.timestamp!.laterDate($1.timestamp!) == $0.timestamp!) ? false : true
        }
        
    }
    
    // Method to reload the table view on the main thread
    //
    func reload() {
        
        // reload the table view
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.tableView.reloadData()
            let finalMessageRow = self.messages.count - 1
            self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: finalMessageRow, inSection: 0), atScrollPosition: UITableViewScrollPosition.Bottom, animated: false)
        }
    }
    
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
    
    // Converts JSON data for a single message threads into a managed object
    //
    func messageWithJSON(json: AnyObject) throws -> CDWSMessage {
        
        // Abort if the message id can not be found.
        guard let message_id = json.valueForKey("mid")?.integerValue else {
            print("Recieved message with no ID")
            throw DataError.InvalidInput
        }
        
        guard let authorUID = json.valueForKey("author")?.integerValue else {
            print("Recieved message with no author")
            throw DataError.InvalidInput
        }
        
        // Get the author from the store
        var author: CDWSUser
        do {
            author = try getUserWithUID(authorUID)
        }
        
        // Check if the message exists in the store.
        var message: CDWSMessage
        do {
            message = try getMessageWithMessageID(message_id)
        }

        // Update the message thread managed object.
        do {
            try message.updateWithJSON(json, andAuthor: author)
            message.thread = messageThread
            message.author = author
        } catch {
            print("Failed to update message thread with id \(message_id)")
            moc.deleteObject(message)
        }
        
        return message
    }
    
    // Checks if a message thread is alread in the store by thread id.
    // Returns the existing messaged thread, or a new message thread inserted into the MOC.
    //
    func getMessageWithMessageID(message_id: Int) throws -> CDWSMessage {
        
        let request = NSFetchRequest(entityName: "CDWSMessage")
        request.predicate = NSPredicate(format: "message_id == %i", message_id)
        
        // Try to find message thread in the store
        do {
            let messages = try moc.executeFetchRequest(request)
            if messages.count != 0 {
                if let message = messages[0] as? CDWSMessage {
                    return message
                }
            }
        } catch {
            throw CoreDataError.FailedFetchReqeust
        }
        
        // Message thread wasn't in the store, so create a new managed object
        let message = NSEntityDescription.insertNewObjectForEntityForName("CDWSMessage", inManagedObjectContext: moc) as! CDWSMessage
        return message
    }
    
    
    // Checks if a user is already in the store by uid.
    // Returns the existing user, or a new user inserted into the MOC.
    //
    func getUserWithUID(uid: Int) throws -> CDWSUser {
        
        let request = NSFetchRequest(entityName: "CDWSUser")
        request.predicate = NSPredicate(format: "uid == %i", uid)
        
        // Try to find the user in the store
        do {
            let users = try moc.executeFetchRequest(request)
            if users.count != 0 {
                if let user = users[0] as? CDWSUser {
                    return user
                }
            }
        } catch {
            throw CoreDataError.FailedFetchReqeust
        }
        
        // User wasn't in the store, so create a new managed object
        let user = NSEntityDescription.insertNewObjectForEntityForName("CDWSUser", inManagedObjectContext: moc) as! CDWSUser
        return user
        
    }
    
    // Appends a message to the table view data source
    func addMessageToDataSource(message: CDWSMessage) {
        messages.append(message)
    }
    
    func addAuthorToDataSource(author: CDWSUser) {
        
        let uid = author.uid!.integerValue
        
        guard getAuthorFromDataSourceWithUID(uid) == nil else {
            return
        }
        
        authors.append(author)
    }
    
    // Returns an author from the data source by uid
    // Returns nil is the user is not in the data source
    //
    func getAuthorFromDataSourceWithUID(uid: Int) -> CDWSUser? {
        return authors.filter{ $0.uid == uid }.first
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
    
    
}
