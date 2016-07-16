//
//  WSComposeMessageViewController.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 27/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit
import CoreData

class WSComposeMessageViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    let detailCellHeight: CGFloat = 40.0
    
    var threadID: Int?
    var recipients: [CDWSUser]?
    var subject: String?
    var body: String?
    
    /** Returns true if threadID is not nil and hence the message is a reply on a existing thread. */
    var isReply: Bool { return threadID != nil }
    
    // Delegates
    let store: WSStoreMessageThreadProtocol = WSStore.sharedStore
    let session: WSSessionStateProtocol = WSSessionState.sharedSessionState
    var alert: WSAlertDelegate = WSAlertDelegate.sharedAlertDelegate
    var api: WSAPICommunicatorProtocol = WSAPICommunicator.sharedAPICommunicator
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure the table view
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 38
        tableView.reloadData()
        
        if isReply {
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
    
    /** Sets up the message as a new message to a give set of hosts. */
    func configureAsNewMessageToUser(users: [CDWSUser]) {
        navigationItem.title = "New Message"
        recipients = users
    }
    
    /** Sets up the message as a reply on a given message thread. */
    func configureAsReply(threadID: Int?) {
        
        guard let threadID = threadID else { return }
        
        // Set the navigation title
        navigationItem.title = "Reply"
        
        // Set up the reply
        self.threadID = threadID
        do {
            let thread = try store.messageThreadWithID(threadID)
            guard let uid = session.uid else { return }
            self.threadID = threadID
            self.subject = thread?.subject
            self.recipients = thread?.otherParticipants(uid)
        } catch {
            // Segue to reply should fail before this
        }
    }
    
    /** Returns a string of comma seperated full names of the message recipients. */
    func recipientStringForRecipients(recipients: [CDWSUser]?, joiner: String = ",") -> String {
        guard let recipients = recipients where recipients.count > 0 else { return "" }
        let names = recipients.map { (user) -> String in user.name! }
        let recipientString = names.joinWithSeparator(joiner)
        return recipientString
    }

}
