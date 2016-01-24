//
//  ComposeMessageTableViewController.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 6/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit
import CoreData
import MBProgressHUD

let COMPOSE_MESSAGE_DETAIL_CELL_ID = "ComposeMessageDetail"
let COMPOSE_MESSAGE_BODY_CELL_ID = "ComposeMessageBody"

class ComposeMessageTableViewController: UITableViewController {
    
    let detailCellHeight: CGFloat = 40.0
    
    var message: CDWSMessage?
    
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
            cell.userInteractionEnabled = false
            return cell
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier(COMPOSE_MESSAGE_DETAIL_CELL_ID, forIndexPath: indexPath) as! ComposeMessageDetailTableViewCell
            cell.detailLabel!.text = "Subject:"
            cell.detailTextField!.text = message?.thread?.subject
            cell.detailTextField!.delegate = self
            return cell
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier(COMPOSE_MESSAGE_BODY_CELL_ID, forIndexPath: indexPath) as! ComposeMessageBodyTableViewCell
            cell.textView.delegate = self
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 && indexPath.row == 2 {
            return tableView.bounds.height - 2 * detailCellHeight - (navigationController?.navigationBar.bounds.height)!
        } else {
            return detailCellHeight
        }
    }
    
    
    // MARK: Utility methods
    
    func getRecipientString() -> String {
        
        guard let recipients = message?.recipients?.allObjects as? [CDWSUser] where recipients.count != 0 else {
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
    
    func initialiseAsNewMessageToUser(user: CDWSUser) {
        
        // Set the navigation title
        navigationItem.title = "New Message"
        
        // Set up the message model
        self.message = NSEntityDescription.insertNewObjectForEntityForName("Message", inManagedObjectContext: moc) as? CDWSMessage
        self.message?.thread = NSEntityDescription.insertNewObjectForEntityForName("MessageThread", inManagedObjectContext: moc) as? CDWSMessageThread
        self.message?.recipients = NSSet(array: [user])
        
        // Set the subject text field as the first responder
        tableView.reloadData()
        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 0)) as! ComposeMessageDetailTableViewCell
        cell.detailTextField.becomeFirstResponder()
    }
    
    func initialiseAsReplyToMessage(message: CDWSMessage) {
        
        // Set the navigation title
        navigationItem.title = "Reply"
        
        // Set up the message model
        self.message = NSEntityDescription.insertNewObjectForEntityForName("Message", inManagedObjectContext: moc) as? CDWSMessage
        self.message?.thread = NSEntityDescription.insertNewObjectForEntityForName("MessageThread", inManagedObjectContext: moc) as? CDWSMessageThread
        self.message?.thread?.thread_id = message.thread?.thread_id
        self.message?.recipients = NSSet(array: [message.author!])
        self.message?.thread?.subject = message.thread?.subject
        
        // Set the body text view as the first responded
        tableView.reloadData()
        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 2, inSection: 0)) as! ComposeMessageBodyTableViewCell
        cell.textView.becomeFirstResponder()
        tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: .Bottom, animated: false)
    }
    
    
    // MARK: - Navigation

    @IBAction func cancelButtonPressed(sender: AnyObject?) {
        
        // Show a warning message if the message body has some content
        guard let body = message?.body where body != "" else {
            let alert = UIAlertController(title: nil, message: "Are you sure you want to discard the current message?", preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            alert.addAction(cancelAction)
            let continueAction = UIAlertAction(title: "Continue", style: .Default) { (continueAction) -> Void in
                self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
            }
            alert.addAction(continueAction)
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        navigationController?.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    @IBAction func sendButtonPressed(sender: AnyObject?) {
        
        self.view.endEditing(true)
        
        if let threadID = message?.thread?.thread_id?.integerValue where threadID > 0 {
            
            // Send message as a reply on an existing thread
            
            guard let body = message?.body where body != "" else {
                let alert = UIAlertController(title: "Could not send message.", message: "Message has no content.", preferredStyle: .Alert)
                let okAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
                alert.addAction(okAction)
                self.presentViewController(alert, animated: true, completion: nil)
                return
            }
            
            // Show the spinner
            showHUD()
            
            WSRequest.replyToMessage(threadID, body: body) { (success) -> Void in
                
                // Remove the spinner
                self.hideHUD()
                
                if success {
                    self.moc.deleteObject(self.message!)
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
                    })
                    self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
                } else {
                    let alert = UIAlertController(title: "Could not send message.", message: "Sorry, an error occured while sending you message. Please check you are connected to the internet and try again later.", preferredStyle: .Alert)
                    let okAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
                    alert.addAction(okAction)
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.presentViewController(alert, animated: true, completion: nil)
                    })
                }
            }
            
        } else {
            
            // Send as a new message
            
            guard message?.recipients != nil else {
                let alert = UIAlertController(title: "Could not send message.", message: "Message has no recipients.", preferredStyle: .Alert)
                let okAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
                alert.addAction(okAction)
                self.presentViewController(alert, animated: true, completion: nil)
                return
            }
            
            guard let subject = message?.thread?.subject where subject != "" else {
                let alert = UIAlertController(title: "Could not send message.", message: "Message has no subject.", preferredStyle: .Alert)
                let okAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
                alert.addAction(okAction)
                self.presentViewController(alert, animated: true, completion: nil)
                return
            }
            
            guard let body = message?.body where body != "" else {
                let alert = UIAlertController(title: "Could not send message.", message: "Message has no content.", preferredStyle: .Alert)
                let okAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
                alert.addAction(okAction)
                self.presentViewController(alert, animated: true, completion: nil)
                return
            }
            
            // Show the spinner
            showHUD()
            
            WSRequest.sendNewMessage(message!, completion: { (success) -> Void in
                
                // Remove the spinner
                self.hideHUD()

                if success {
                    self.moc.deleteObject(self.message!)
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
                    })
                } else {
                    let alert = UIAlertController(title: "Could not send message.", message: "Sorry, an error occured while sending your message. Please check you are connected to the internet then try again later.", preferredStyle: .Alert)
                    let okAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
                    alert.addAction(okAction)
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.presentViewController(alert, animated: true, completion: nil)
                    })
                    
                }
            })
        }
    }
    
    func showHUD() {
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.labelText = "Sending message ..."
        hud.dimBackground = true
        hud.removeFromSuperViewOnHide = true
    }
    
    func hideHUD() {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            MBProgressHUD.hideHUDForView(self.view, animated: true)
        })
    }

}
