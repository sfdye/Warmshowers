//
//  MessageThreadsTableViewController.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 1/12/15.
//  Copyright © 2015 Rajan Fernandez. All rights reserved.
//

import UIKit
import CoreData
import MBProgressHUD

let MESSAGE_THREAD_CELL_ID = "MessageThreadCell"
let MESSAGE_SEGUE_ID = "ToMessageThread"

class MessageThreadsTableViewController: UITableViewController {
    
    // MARK: Properties

    var currentUserUID: Int {
        let defaults = NSUserDefaults.standardUserDefaults()
        return defaults.integerForKey(DEFAULTS_KEY_UID)
    }
    
    let moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var messageThreads = [CDWSMessageThread]()
    var users = [CDWSUser]()
    
    var refreshController = UIRefreshControl()
    var lastUpdated: NSDate?
    var updatesInProgress = [Int: WSMessageThreadUpdater]()
    var alert: UIAlertController?
    
    
    // MARK: View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Messages"
        
        // set the refresh controller for the tableview
        refreshController.addTarget(self, action: Selector("update"), forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = self.refreshController
        
        // Fetch all messages from the store
        // Try to find message thread in the store
        let request = NSFetchRequest(entityName: "MessageThread")
        do {
            messageThreads = try moc.executeFetchRequest(request) as! [CDWSMessageThread]
        } catch {
            print("Failed to get message from the store")
        }
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 96
        
//            {
//                count = 1;
//                "has_tokens" = 0;
//                "is_new" = 0;
//                "last_updated" = 1452588123;
//                participants =     (
//                    {
//                        fullname = "Rajan Fernandez";
//                        name = RajanFernandez;
//                        uid = 67118;
//                    },
//                    {
//                        fullname = "Rajan Fernandez AppTest";
//                        name = RajanFernandezAPPTEST;
//                        uid = 105770;
//                    }
//                );
//                subject = Test;
//                "thread_id" = 1714292;
//                "thread_started" = 1452588123;
//        }
        
//            {
//                messages =     (
//                    {
//                        author = 67118;
//                        body = Test;
//                        "is_new" = 0;
//                        mid = 1714292;
//                        timestamp = 1452588123;
//                    }
//                );
//                participants =     (
//                    {
//                        fullname = "Rajan Fernandez";
//                        name = RajanFernandez;
//                        uid = 67118;
//                    },
//                    {
//                        fullname = "Rajan Fernandez AppTest";
//                        name = RajanFernandezAPPTEST;
//                        uid = 105770;
//                    }
//                );
//                pmtid = 1714292;
//                subject = Test;
//        }

//        
//        WSRequest.getMessageThread(1714292, withMessageThreadData: { (data) -> Void in
//            print("IN CALLBACK")
//            if let data = data {
//                print("got data")
//                if let json = WSRequest.jsonDataToJSONObject(data) {
//                    print(json)
//                    if let messagesJSON = json.valueForKey("messages") as? NSArray {
//                        for messageJSON in messagesJSON {
//                            
//                        }
//                    }
//                }
//            }
//        })
        
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: WSColor.Green,
            NSFontAttributeName: WSFont.SueEllenFrancisco(26)]
    }
    
    override func viewDidAppear(animated: Bool) {
        
        var needsUpdate = false
        
        // Update the message threads if more than 10 minutes has elapsed
        if lastUpdated == nil {
            needsUpdate = true
        } else if lastUpdated!.timeIntervalSinceNow > 2 {
            needsUpdate = true
        }
        
        if needsUpdate {
            showHUD()
            update()
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageThreads.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(MESSAGE_THREAD_CELL_ID, forIndexPath: indexPath) as! MessageThreadsTableViewCell
        
        let messageThread = messageThreads[indexPath.row]
        
        cell.participantsLabel.text = messageThread.getParticipantString(currentUserUID)
        cell.subjectLabel.text = messageThread.subject
        cell.setDate(messageThread.last_updated)
        
        if messageThread.is_new != 0 {
            cell.newDot.hidden = false
        } else {
            cell.newDot.hidden = true
        }
        
        if let latest = messageThread.lastestMessage() {
            // set the body preview
            if var preview = latest.body {
                preview += "\n"
                // TODO remove blank lines from the message body so the preview doens't display blanks
                cell.bodyPreviewLabel.text = preview
            }
        } else {
            cell.bodyPreviewLabel.text = ""
        }
        
//        if messages.count == messageThread.count?.integerValue {
//            print(indexPath.row)
//            
//        } else {
//            cell.bodyPreviewLabel.text = ""
//            updateMessagesForThread(messageThread, completion: { () -> Void in
//                dispatch_async(dispatch_get_main_queue(), {
//                    self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
//                })
//            })
//        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
    // MARK: RESTful request methods
    
    // Requests all messages threads from the server and updates the store.
    //
    func update() {
        
        // Clear the context / table view data source
        messageThreads = [CDWSMessageThread]()
        
        WSRequest.getAllMessageThreads({ (data) -> Void in
            
            if let data = data {
                // Parse the message thread data
                let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                dispatch_async(queue, { () -> Void in
                    self.parseMessageThreads(data)
                })
            } else {
                // TODO check for internet connection here and diplay an alert
//                WSRequest.checkReachability()
                self.refreshController.endRefreshing()
            }
        })
    }
    
    
    // MARK: Utility methods
    
    // Parses JSON data containing messages threads and updates the store.
    //
    func parseMessageThreads(data: NSData) {
        
        guard let json = WSRequest.jsonDataToJSONObject(data) else {
            reloadIfUpdatesAreFinished()
            return
        }
        
        guard let threadsJSON = json as? NSArray else {
            reloadIfUpdatesAreFinished()
            return
        }
        
        // Parse the json
        for threadJSON in threadsJSON {
            // Parse the message thread data
            do {
                let messageThread = try messageThreadWithJSON(threadJSON)
                messageThreads.append(messageThread)
            } catch DataError.InvalidInput {
                print("Failed to save message due to invalid input")
            } catch DataError.FailedConversion {
                print("Failed to create message participant due to a failed data conversion")
            } catch CDWSMessageThreadError.FailedValueForKey(let key) {
                print("Failed to update message thread due to invalid input for key '\(key)'")
            } catch CDWSMessageParticipantError.FailedValueForKey(let key) {
                print("Failed to update message participant due to invalid input for key '\(key)'")
            } catch CoreDataError.FailedFetchReqeust {
                print("Failed to save message due to a fail Core Data fetch request")
            } catch {
                print("Failed to create message participant for an unknown error")
            }
        }

        // Delete all threads from the store that are not in the json
        // TODO clear all threads in array 'threadIDs'
        
        // Sort the messages
        messageThreads.sortInPlace {
            return $0.last_updated!.laterDate($1.last_updated!).isEqualToDate($0.last_updated!)
        }
        
        // Run updates on message threads
        for thread in messageThreads {
            if thread.needsUpdating() {
                setUpdaterForThread(thread)
            }
        }
        if updatesInProgress.count > 0 {
            startAllMessageUpdaters()
        } else {
            reloadIfUpdatesAreFinished()
        }
        
    }
    
    // Converts JSON data for a single message threads into a managed object
    //
    func messageThreadWithJSON(json: AnyObject) throws -> CDWSMessageThread {
        
        // Abort if the thread id can not be found.
        guard let thread_id = json.valueForKey("thread_id")?.integerValue else {
            print("Recieved message thread with no ID")
            throw DataError.InvalidInput
        }
        
        // Check if the thread exists in the store.
        var messageThread: CDWSMessageThread
        do {
            messageThread = try getMessageThreadWithThreadID(thread_id)
        }
        
        // Update the message thread managed object.
        do {
            try messageThread.updateWithJSON(json)
        } catch {
            print("Failed to update message thread with id \(thread_id)")
            moc.deleteObject(messageThread)
        }
        
        // Update the participants if neccessary
        if messageThread.participants?.count == 0 {
            
            // Get an array of the message participants.
            var participants = NSSet()
            let participantsJSON = json.valueForKey("participants")
            do {
                try participants = getMessageParticipantSet(participantsJSON)
            }
            messageThread.participants = participants
        }

        return messageThread
    }
    
    // Checks if a message thread is alread in the store by thread id.
    // Returns the existing messaged thread, or a new message thread inserted into the MOC.
    //
    func getMessageThreadWithThreadID(thread_id: Int) throws -> CDWSMessageThread {
        
        // Try to find message thread in the store
        let request = NSFetchRequest(entityName: "MessageThread")
        request.predicate = NSPredicate(format: "thread_id == %i", thread_id)
        do {
            let threads = try moc.executeFetchRequest(request)
            if threads.count != 0 {
                if let messageThread = threads[0] as? CDWSMessageThread {
                    return messageThread
                }
            }
        } catch {
            throw CoreDataError.FailedFetchReqeust
        }
        
        // Message thread wasn't in the store, so create a new managed object
        let messageThread = NSEntityDescription.insertNewObjectForEntityForName("MessageThread", inManagedObjectContext: moc) as! CDWSMessageThread
        return messageThread
    }
    
    // Checks if a user is already in the store by uid.
    // Returns the existing user, or a new user inserted into the MOC.
    //
    func getUserWithUID(uid: Int) throws -> CDWSUser {
        
        let request = NSFetchRequest(entityName: "User")
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
        let user = NSEntityDescription.insertNewObjectForEntityForName("User", inManagedObjectContext: moc) as! CDWSUser
        return user
        
    }
    
    // Makes a set of message participants from JSON data
    //
    func getMessageParticipantSet(json: AnyObject?) throws -> NSSet {
        
        guard json != nil else {
            throw DataError.InvalidInput
        }
        
        guard let users = json as? NSArray else {
            throw DataError.FailedConversion
        }
        
        var participants = [CDWSUser]()
        for user in users {
            
            // Get the user uid of the message participant.
            if let uid = user.valueForKey("uid")?.integerValue {
                
                // Check if the participant exists in the store.
                var participant: CDWSUser
                do {
                    participant = try getUserWithUID(uid)
                }
                
                // Update the message participant data.
                do {
                    try participant.updateFromMessageParticipantJSON(user)
                }
                participants.append(participant)
                
            } else {
                throw DataError.InvalidInput
            }
        }
        
        return NSSet(array: participants)
    }
    
    // Sets an updater for a message thread, but does not start it
    //
    func setUpdaterForThread(messageThread: CDWSMessageThread, completion: (() -> Void)? = nil ) {
        
        guard let threadID = messageThread.thread_id?.integerValue else {
            return
        }
        
        let messageUpdater = WSMessageThreadUpdater(messageThread: messageThread, inManagedObjectContext: moc)
        messageUpdater.success = {
            completion?()
            self.updateFinishedForThreadID(threadID)
        }
        messageUpdater.failure = {
            self.updateFinishedForThreadID(threadID)
            self.setFailedUpdateAlert()
        }
        updatesInProgress[threadID] = messageUpdater
    }
    
    // Starts all updaters in the updates in progress dictionary
    //
    func startAllMessageUpdaters() {
        
        guard updatesInProgress.count > 0 else {
            return
        }
        
        for (_, update) in updatesInProgress {
            update.start()
        }
    }
    
    func updateFinishedForThreadID(threadID: Int) {
        self.updatesInProgress.removeValueForKey(threadID)
        self.reloadIfUpdatesAreFinished()
    }
    
    func reloadIfUpdatesAreFinished() {
        if updatesInProgress.count == 0 {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                // save messages to the store
                do {
                    try self.moc.save()
                } catch let error as NSError {
                    print("Could not save MOC. \(error.localizedDescription)")
                }
                
                // Reload the table view
                self.tableView.reloadData()
                
                // Hide refreshing indicators and show any error alerts that were set
                self.refreshController.endRefreshing()
                self.hideHUD()
                self.showAlert()
            })
        }
    }
    
    // Sets an failed update alert to be displayed at the end of the updates
    func setFailedUpdateAlert() {
        alert = UIAlertController(title: "Failed to update messages", message: "Please check that you are connected to the internet and try again", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert!.addAction(okAction)
    }
    
    // Presents any alerts set during message updates
    func showAlert() {
        
        guard let alert = alert else {
            return
        }
        
        dispatch_async(dispatch_get_main_queue(), {
            self.presentViewController(alert, animated: true, completion: nil)
        })
        
        self.alert = nil
    }
    
    func showHUD() {
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.labelText = "Updating messages ..."
        hud.dimBackground = true
        hud.removeFromSuperViewOnHide = true
    }
    
    func hideHUD() {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            MBProgressHUD.hideHUDForView(self.view, animated: true)
        })
    }
    
    
    // MARK: Navigation
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if identifier == MESSAGE_SEGUE_ID {
            if sender is MessageThreadsTableViewCell {
                return true
            }
        }
        return false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == MESSAGE_SEGUE_ID {
            let messageThreadVC = segue.destinationViewController as! MessageThreadTableViewController
            let cell = sender as! MessageThreadsTableViewCell
//            messageThreadVC.threadID = cell.threadID
        }
    }
    
    

//    func getMessageThread(threadID: Int16) -> MessageThread {
//
//        return mt
//    }
    
//    // MARK: Segment control
//
//    @IBAction func segmentControlDidChange(sender: AnyObject) {
//        
//        let segment = sender as! UISegmentedControl
//        
//        switch segment.selectedSegmentIndex {
//        case 0:
//            print("inbox")
//        case 1:
//            print("sent")
//        case 2:
//            print("all")
//        case 3:
//            print("requests")
//        default:
//            return
//        }
//    
//    }
}
