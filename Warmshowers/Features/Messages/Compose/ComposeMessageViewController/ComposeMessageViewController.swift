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
    var recipients: [String]?
    var subject: String?
    var body: String?
    
    weak var delegate: ComposeMessageViewControllerDelegate?
    
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
    func configureAsNewMessage(toRecipientsWithUsernames usernames: [String]) {
        navigationItem.title = NSLocalizedString("New Message", tableName: "Compose", comment: "New message view navigation bar title")
        recipients = usernames
    }
    
    /** Sets up the message as a reply on a given message thread. */
    func configureAsReply(_ threadID: Int?) {
        
        guard let threadID = threadID else { return }
        
        // Set the navigation title
        navigationItem.title = NSLocalizedString("Reply", tableName: "Compose", comment: "Message reply view navigation bar title")
        
        // Set up the reply
        let predicate = NSPredicate(format: "p_thread_id == %d", threadID)
        guard let thread: MOMessageThread = try! store.retrieve(inContext: store.managedObjectContext, withPredicate: predicate, andSortBy: nil, isAscending: true).first
            else { return }
        guard let uid = session.uid else { return }
        self.threadID = threadID
        self.subject = thread.subject
        self.recipients = thread.namesOfParticipants(excludingUserWithUID: uid)
    }
    
    /** Returns a string of comma seperated full names of the message recipients. */
    func recipientString(forRecipientUsernames usernames: [String]?, joiner: String = ",") -> String {
        guard let usernames = usernames, usernames.count > 0 else { return "" }
        let recipientString = usernames.joined(separator: joiner)
        return recipientString
    }

}
