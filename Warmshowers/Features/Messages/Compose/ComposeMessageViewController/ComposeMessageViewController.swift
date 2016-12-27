//
//  ComposeMessageViewController.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 27/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit
import CoreData
import WarmshowersData

class ComposeMessageViewController: UIViewController, Delegator, DataSource {
    
    @IBOutlet var tableView: UITableView!
    
    let detailCellHeight: CGFloat = 40.0
    
    var threadID: Int?
    var recipients: [MOUser]?
    var subject: String?
    var body: String?
    
    /** Returns true if threadID is not nil and hence the message is a reply on a existing thread. */
    var isReply: Bool { return threadID != nil }
    
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
            let cell = tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as! ComposeMessageBodyTableViewCell
            cell.textView.becomeFirstResponder()
        } else {
            // Set the subject text field as the first responder
            let cell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! ComposeMessageDetailTableViewCell
            cell.detailTextField.becomeFirstResponder()
        }
    }
    
    
    // MARK: Utility methods
    
    /** Sets up the message as a new message to a give set of hosts. */
    func configureAsNewMessageToUsers(_ users: [MOUser]) {
        navigationItem.title = "New Message"
        recipients = users
    }
    
    /** Sets up the message as a reply on a given message thread. */
    func configureAsReply(_ threadID: Int?) {
        
        guard let threadID = threadID else { return }
        
        // Set the navigation title
        navigationItem.title = "Reply"
        
        // Set up the reply
        let predicate = NSPredicate(format: "p_thread_id == %d", threadID)
        guard let thread: MOMessageThread = try! store.retrieve(inContext: store.managedObjectContext, withPredicate: predicate, andSortBy: nil, isAscending: true).first
            else { return }
        guard let uid = session.uid else { return }
        self.threadID = threadID
        self.subject = thread.subject
        self.recipients = thread.otherParticipants(currentUserUID: uid)
    }
    
    /** Returns a string of comma seperated full names of the message recipients. */
    func recipientStringForRecipients(_ recipients: [MOUser]?, joiner: String = ",") -> String {
        guard let recipients = recipients , recipients.count > 0 else { return "" }
        let names = recipients.map { (user) -> String in user.name! }
        let recipientString = names.joined(separator: joiner)
        return recipientString
    }

}
