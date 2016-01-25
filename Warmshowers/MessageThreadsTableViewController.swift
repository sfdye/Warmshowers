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
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var messageThreads = [CDWSMessageThread]()
    var messageThreadUpdater: WSMessageThreadsUpdater!
    var queue = NSOperationQueue()
    
    var refreshController = UIRefreshControl()
    var lastUpdated: NSDate?
    var updatesInProgress = [Int: WSMessageThreadUpdater]()
    var alert: UIAlertController?
    
    
    // MARK: View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Messages"
        
        // Set the refresh controller for the tableview
        refreshController.addTarget(self, action: Selector("startUpdates"), forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = self.refreshController
        
        // Set up the message parsing queue
        queue.maxConcurrentOperationCount = 1
        
        // Set up the message thread updater
        messageThreadUpdater = WSMessageThreadsUpdater(moc: moc)
        messageThreadUpdater.success = {
            self.lastUpdated = NSDate()
            self.updateDataSource()
            self.updateTabBarBadge()
            self.updateMessages()
            self.reloadIfUpdatesAreFinished()
        }
        messageThreadUpdater.failure = {
            if let error = self.messageThreadUpdater.error {
                self.alert = UIAlertController(title: "Failed to update messages", message: error.localizedDescription, preferredStyle: .Alert)
                let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                self.alert!.addAction(okAction)
            } else {
                self.setFailedUpdateAlert()
            }
            self.refreshController.endRefreshing()
            WSProgressHUD.hide()
            self.showAlert()
        }
        
        // Table view autolayout options
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 96
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
        } else if lastUpdated!.timeIntervalSinceNow > 600 {
            needsUpdate = true
        }
        
        if needsUpdate {
            startUpdates()
        } else {
            // Just reload to update the read indicators and the tab bar badge
            tableView.reloadData()
            updateTabBarBadge()
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
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
    // MARK: Utility methods
    
    // Starts updating message threads
    //
    func startUpdates() {
        WSProgressHUD.show("Updating messages ...")
        messageThreadUpdater.start()
    }
    
    // Fetches all messages from the store and updates the tableview data
    //
    func updateDataSource() {
        
        // Clear the context / table view data source
        messageThreads = [CDWSMessageThread]()
        
        // Get the currently saved message threads from the store
        let request = NSFetchRequest(entityName: "MessageThread")
        do {
            messageThreads = try moc.executeFetchRequest(request) as! [CDWSMessageThread]
        } catch {
            print("fetch fail.")
        }
        
        // Sort the message threads
        sortMessageThreads()
    }
    
    func sortMessageThreads() {
        
        // Sort the messages by date
        messageThreads.sortInPlace({
            return $0.last_updated!.laterDate($1.last_updated!).isEqualToDate($0.last_updated!)
        })
        
    }
    
    // Checks that messages in each thread are up-to-date an downloads required messages
    //
    func updateMessages() {
        
        for thread in messageThreads {
            if let messages = thread.messages, let count = thread.count?.integerValue {
                if messages.count != count {
                    setUpdaterForThread(thread)
                }
            }
        }
        startAllMessageUpdaters()
    }
    
    // Sets an updater for a message thread, but does not start it
    //
    func setUpdaterForThread(messageThread: CDWSMessageThread, completion: (() -> Void)? = nil ) {
        
        guard let threadID = messageThread.thread_id?.integerValue else {
            return
        }
        
        let messageUpdater = WSMessageThreadUpdater(messageThread: messageThread, inManagedObjectContext: moc, queue: queue)
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
    
    // Removes the message updater object assign to a given thread and reloads the table if all updates are done
    //
    func updateFinishedForThreadID(threadID: Int) {
        self.updatesInProgress.removeValueForKey(threadID)
        self.reloadIfUpdatesAreFinished()
    }
    
    // Reloads the table view if there are no message updaters left in updatesInProgress
    //
    func reloadIfUpdatesAreFinished() {
        if updatesInProgress.count == 0 {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                // Reload the table view
                self.tableView.reloadData()
                
                // Hide refreshing indicators and show any error alerts that were set
                self.refreshController.endRefreshing()
                WSProgressHUD.hide()
                self.showAlert()
            })
        }
    }
    
    // Checks how many message threads have unread messages
    //
    func numberOfUnreadThreads() -> Int {
        var count: Int = 0
        for thread in messageThreads {
            if thread.is_new!.boolValue {
                count++
            }
        }
        return count
    }
    
    // Update the tab bar badge with the number of unread threads
    //
    func updateTabBarBadge() {
        let unread = self.numberOfUnreadThreads()
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            if unread > 0 {
                self.navigationController?.tabBarItem.badgeValue = String(unread)
            } else {
                self.navigationController?.tabBarItem.badgeValue = nil
            }
        }
    }
    
    // Sets an failed update alert to be displayed at the end of the updates
    //
    func setFailedUpdateAlert() {
        alert = UIAlertController(title: "Failed to update messages", message: "Please check that you are connected to the internet and try again", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert!.addAction(okAction)
    }
    
    // Presents any alerts set during message updates
    //
    func showAlert() {
        
        guard let alert = alert else {
            return
        }
        
        dispatch_async(dispatch_get_main_queue(), {
            self.presentViewController(alert, animated: true, completion: { () -> Void in
                self.alert = nil
            })
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
            
            // Get the message thread from the table view data source
            let cell = sender as! MessageThreadsTableViewCell
            let indexPath = tableView.indexPathForCell(cell)
            let messageThread = messageThreads[indexPath!.row] as CDWSMessageThread
            var messages = messageThread.messages?.allObjects as! [CDWSMessage]
            let authors = messageThread.participants?.allObjects as! [CDWSUser]
            
            // Sort the messages by date
            messages.sortInPlace({
                return $0.timestamp!.laterDate($1.timestamp!).isEqualToDate($1.timestamp!)
            })
            
            // Assign the message thread data to the destination view controller
            let messageThreadVC = segue.destinationViewController as! MessageThreadTableViewController
            messageThreadVC.messageThread = messageThread
            messageThreadVC.messages = messages
            messageThreadVC.authors = authors
        }
    }
    
    
// ------------
    
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
