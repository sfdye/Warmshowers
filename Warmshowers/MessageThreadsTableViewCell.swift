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
    @IBOutlet weak var newDot: UIImageView!
    var threadID: Int!
    
    func configureWithMessageThread(messageThread: CDWSMessageThread, andCurrentUserUID uid: Int) {
        self.threadID = messageThread.thread_id?.integerValue
        // TODO setup body preview
        self.bodyPreviewLabel.text = ""
        setDate(messageThread.last_updated)
        self.participantsLabel.text = messageThread.getParticipantString(uid)
        self.subjectLabel.text = messageThread.subject
        if messageThread.is_new != 0 {
            newDot.hidden = false
        } else {
            newDot.hidden = true
        }
    }
    
    func setDate(date: NSDate?) {
        if date != nil {
            let formatter = NSDateFormatter()
            let template = "HHmmddMMMyyyy"
            let locale = NSLocale.currentLocale()
            formatter.dateFormat = NSDateFormatter.dateFormatFromTemplate(template, options: 0, locale: locale)
            dateLabel.text = formatter.stringFromDate(date!)
        }
    }

}
