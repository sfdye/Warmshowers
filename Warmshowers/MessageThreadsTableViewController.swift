//
//  MessageThreadsTableViewController.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 1/12/15.
//  Copyright © 2015 Rajan Fernandez. All rights reserved.
//

import UIKit
import CoreData

let MESSAGE_THREAD_CELL_ID = "MessageThreadCell"
let MESSAGE_SEGUE_ID = "ToMessageThread"

class MessageThreadsTableViewController: UITableViewController {
    
    // MARK: Properties

    var currentUserUID: Int? {
        let defaults = NSUserDefaults.standardUserDefaults()
        return defaults.integerForKey(DEFAULTS_KEY_UID)
    }
    
    
    
    let moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var messageThreads = [CDWSMessageThread]()
    var users = [CDWSUser]()
    
    var refreshController = UIRefreshControl()
    
    
    // MARK: View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set the refresh controller for the tableview
        refreshController.addTarget(self, action: Selector("update"), forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = self.refreshController
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        // Update the data source
        update()
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
        cell.configureWithMessageThread(messageThreads[indexPath.row], andCurrentUserUID: currentUserUID!)
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
    // MARK: RESTful request methods
    
    // Requests all messages threads from the server and updates the store.
    //
    func update() {
        
        WSRequest.getAllMessageThreads({ (data) -> Void in
            
            if data != nil {
                let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                dispatch_async(queue, { () -> Void in
                    self.parseMessageThreads(data!)
                })
            } else {
                // TODO check for internet connection here and diplay an alert
//                WSRequest.checkReachability()
                self.refreshController.endRefreshing()
                self.fetchAndReload()
            }
        })
    }
    
    
    // MARK: Utility methods
    
    // Parses JSON data containing messages threads and updates the store.
    //
    func parseMessageThreads(data: NSData) {
        
        // clear old thread data
        messageThreads = [CDWSMessageThread]()
        
        // parse the json
        if let json = WSRequest.jsonDataToJSONObject(data) {
            if let threadsJSON = json as? NSArray {
                for threadJSON in threadsJSON {
                    do {
                        try messageThreadWithJSON(threadJSON)
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
            }
        }
        
        // save messages to the store
        do {
            try moc.save()
        } catch {
            print("Could not save MOC.")
        }
        
        // End refreshing
        self.refreshController.endRefreshing()
        
        // fetch the saved data and reload the tableview
        fetchAndReload()
        
    }
    
    // Converts JSON data for a single message threads into a managed object
    //
    func messageThreadWithJSON(json: AnyObject) throws {
        
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
        
        // Get an array of the message participants.
        var participants = NSSet()
        let participantsJSON = json.valueForKey("participants")
        do {
            try participants = getMessageParticipantSet(participantsJSON)
        }
        
        // Update the message thread managed object.
        do {
            try messageThread.updateWithJSON(json, AndParticipantSet: participants)
        } catch {
            print("Failed to update message thread with id \(thread_id)")
            moc.deleteObject(messageThread)
        }
    }
    
    // Checks if a message thread is alread in the store by thread id.
    // Returns the existing messaged thread, or a new message thread inserted into the MOC.
    //
    func getMessageThreadWithThreadID(thread_id: Int) throws -> CDWSMessageThread {
        
        let request = NSFetchRequest(entityName: "CDWSMessageThread")
        request.predicate = NSPredicate(format: "thread_id == %i", thread_id)
        
        // Try to find message thread in the store
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
        let messageThread = NSEntityDescription.insertNewObjectForEntityForName("CDWSMessageThread", inManagedObjectContext: moc) as! CDWSMessageThread
        return messageThread
        
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
    
    // Fetches data from the store and reloads the tableview
    func fetchAndReload() {
        
        // fetch all threads from the store
        let request = NSFetchRequest(entityName: "CDWSMessageThread")
        let sortDescriptor = NSSortDescriptor(key: "last_updated", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        do {
            messageThreads = try moc.executeFetchRequest(request) as! [CDWSMessageThread]
        } catch {
            print("Failed to fetch data from the store")
        }
        
        // reload the table view
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.tableView.reloadData()
        }
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
            messageThreadVC.threadID = cell.threadID
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
