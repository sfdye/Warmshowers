//
//  MessageThreadTableViewCell.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 1/12/15.
//  Copyright © 2015 Rajan Fernandez. All rights reserved.
//

import UIKit

class MessageThreadsTableViewCell: UITableViewCell {
    
    // MARK: Properties
    
    @IBOutlet weak var bodyPreviewLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var participantsLabel: UILabel!
    @IBOutlet weak var subjectLabel: UILabel!
    var threadID: Int!
    
    func configureWithMessageThread(messageThread: CDWSMessageThread, andCurrentUserUID uid: Int) {
        self.threadID = messageThread.thread_id?.integerValue
        // TODO setup body preview
        self.bodyPreviewLabel.text = ""
        // TODO setup message thread last edited date
        self.dateLabel.text = ""
        self.participantsLabel.text = messageThread.getParticipantString(uid)
        self.subjectLabel.text = messageThread.subject
    }

}
