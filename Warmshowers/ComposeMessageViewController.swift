//
//  ComposeMessageViewController.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 27/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit
import CoreData

let ComposeMessageDetailCellID = "ComposeMessageDetail"
let ComposeMessageBodyCellID = "ComposeMessageBody"

class ComposeMessageViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    let detailCellHeight: CGFloat = 40.0
    
    var currentUserUID: Int {
        let defaults = NSUserDefaults.standardUserDefaults()
        return defaults.integerForKey(defaults_key_uid)
    }
    
    var recipients: [CDWSUser]?
    var subject: String?
    var body: String?
    var threadID: Int?
    var replyOnMessageThread: CDWSMessageThread?
    
    var messageSender: WSMessageSender?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure the table view
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 38
        tableView.reloadData()
        
        if isReply() {
            // Set the body text view as the first responder
            let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 2, inSection: 0)) as! ComposeMessageBodyTableViewCell
            cell.textView.becomeFirstResponder()
        } else {
            // Set the subject text field as the first responder
            let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 0)) as! ComposeMessageDetailTableViewCell
            cell.detailTextField.becomeFirstResponder()
        }
    }
    
    // MARK: Utility methods
    
    // Returns true if threadID is not nil and hence the message is a reply on a existing thread
    //
    func isReply() -> Bool {
        return threadID != nil
    }
    
    // Returns a string of comma seperated full names of the message recipients
    //
    func getRecipientString() -> String {
        
        guard let recipients = recipients where recipients.count != 0 else {
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
    
    // Sets up the message as a new message to a give set of hosts
    //
    func initialiseAsNewMessageToUser(users: [CDWSUser]) {
        
        // Set the navigation title
        navigationItem.title = "New Message"
        
        // Set up the message
        recipients = users
    }
    
    // Sets up the message as a reply on a given message thread
    //
    func initialiseAsReplyOnMessageThread(messageThread: CDWSMessageThread) {
        
        // Set the navigation title
        navigationItem.title = "Reply"
        
        // Set up the reply
        let participants = messageThread.participants?.allObjects as! [CDWSUser]
        recipients = participants.filter( {$0.uid != currentUserUID} )
        subject = messageThread.subject
        threadID = messageThread.thread_id?.integerValue
    }
    
    
    // MARK: - Navigation
    
    @IBAction func cancelButtonPressed(sender: AnyObject?) {
        
        // Show a warning message if the message body has some content
        guard let body = body where body != "" else {
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
        
        guard let body = body where body != "" else {
            let alert = UIAlertController(title: "Could not send message.", message: "Message has no content.", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
            alert.addAction(okAction)
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        guard let recipients = recipients else {
            let alert = UIAlertController(title: "Could not send message.", message: "Message has no recipients.", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
            alert.addAction(okAction)
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        guard let subject = subject where subject != "" else {
            let alert = UIAlertController(title: "Could not send message.", message: "Message has no subject.", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
            alert.addAction(okAction)
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        if let threadID = threadID {
            // Send message as a reply on an existing thread
            messageSender = WSMessageSender(threadID: threadID, body: body)
        } else {
            // Send as a new message
            messageSender = WSMessageSender(recipients: recipients, subject: subject, body: body)
        }
        
        messageSender?.success = self.successfulSend
        messageSender?.failure = self.failedSend
        sendMessage()
    }
    
    func sendMessage() {
        if messageSender != nil {

            // Show the spinner
            WSProgressHUD.show(self.view, label: "Sending message ...")

            // Start the message sender
            messageSender!.tokenGetter.start()
        }
    }
    
    func successfulSend() {
        WSProgressHUD.hide(self.view)
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
        })
    }
    
    func failedSend() {
        WSProgressHUD.hide(self.view)
        messageSender = nil
        let alert = UIAlertController(title: "Could not send message.", message: "Sorry, an error occured while sending you message. Please check you are connected to the internet and try again later.", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
        alert.addAction(okAction)
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.presentViewController(alert, animated: true, completion: nil)
        })
    }

}
