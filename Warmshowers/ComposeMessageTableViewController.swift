//
//  ComposeMessageTableViewController.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 6/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit
import CoreData

let COMPOSE_MESSAGE_DETAIL_CELL_ID = "ComposeMessageDetail"
let COMPOSE_MESSAGE_BODY_CELL_ID = "ComposeMessageBody"

class ComposeMessageTableViewController: UITableViewController {
    
    let detailCellHeight: CGFloat = 40.0
    
    var recipients = [CDWSUser]()
    var subject: String = ""
    
    var replyThreadID: Int?
    
    var moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var httpRequest = WSRequest()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure the table view
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 38
        
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier(COMPOSE_MESSAGE_DETAIL_CELL_ID, forIndexPath: indexPath) as! ComposeMessageDetailTableViewCell
            cell.detailLabel!.text = "To:"
            cell.detailTextField!.text = getRecipientString()
            return cell
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier(COMPOSE_MESSAGE_DETAIL_CELL_ID, forIndexPath: indexPath) as! ComposeMessageDetailTableViewCell
            cell.detailLabel!.text = "Subject:"
            cell.detailTextField!.text = subject
            return cell
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier(COMPOSE_MESSAGE_BODY_CELL_ID, forIndexPath: indexPath) as! ComposeMessageBodyTableViewCell
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 && indexPath.row == 2 {
            return tableView.bounds.height - 2 * detailCellHeight - (navigationController?.navigationBar.bounds.height)!
        }
        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0))
        return detailCellHeight
    }
    
    
    // MARK: Utility methods
    
    func getRecipientString() -> String {
        
        guard recipients.count != 0 else {
            return ""
        }
        
        var recipientString = ""
        for user in recipients {
            if recipientString == "" {
                recipientString += user.fullname!
            } else {
                recipientString += ", " + user.fullname!
            }
        }
        return recipientString
    }
    
    func initialiseAsNewMessageToUser(uid: Int) {
        
        
    }
    
    func initialiseAsReplyToMessage(message: CDWSMessage) {
        
        replyThreadID = message.thread!.thread_id!.integerValue
        recipients = [message.author!]
        subject = message.thread!.subject!
    }
    
    
    // MARK: - Navigation

    @IBAction func cancelButtonPressed(sender: AnyObject?) {
        
        // TODO add a warning alert here if the message is not empty
        
        navigationController?.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    @IBAction func sendButtonPressed(sender: AnyObject?) {
        
        // TODO send the reply
        guard let threadID = replyThreadID else {
            return
        }
        
//        guard let body = ... else {
//            return
//        }
//        
//        httpRequest.replyToMessage(threadID, body: body) { (success) -> Void in
//            <#code#>
//        }
    }

}
