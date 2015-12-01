//
//  MessageThreadsTableViewController.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 1/12/15.
//  Copyright © 2015 Rajan Fernandez. All rights reserved.
//

import UIKit

class MessageThreadsTableViewController: UITableViewController {
    
    // MARK: Properties
    
    let MESSAGE_THREAD_CELL_ID = "MessageThreadCell"
    
    let httpClient = WSRequest()
    var alertController: UIAlertController?
    
    var messageThreads = [MessageThread]()
    
    
    // MARK: View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Allows the http client to diplay alerts through this view controller
        httpClient.alertViewController = self
        
        
        httpClient.getMessageThreads({ (data) -> Void in
            
            if data != nil {
                let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                dispatch_async(queue, { () -> Void in
                    self.updateThreadList(data!)
                })
            }
        })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateThreadList(data: NSData) {
        
        // clear old thread data
        messageThreads = [MessageThread]()
        
        // parse the json
        if let json = self.httpClient.jsonDataToJSONObject(data) {
            if let threads = json as? NSArray {
                for thread in threads {
                    if let mt = MessageThread.initFromJSONObject(thread) {
                        messageThreads.append(mt)
                    }
                }
            }
        }
    
        // reload the table view
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.tableView.reloadData()
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
        
        let cell = tableView.dequeueReusableCellWithIdentifier(MESSAGE_THREAD_CELL_ID, forIndexPath: indexPath) as! MessageThreadTableViewCell
        
        let mt = messageThreads[indexPath.row]
        
        cell.participants.text = mt.getParticipantString()
        cell.subject.text = mt.subject
        cell.message.text = ""
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }


}
