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
    
    @IBOutlet weak var participantsLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var bodyPreviewLabel: UILabel!
    @IBOutlet weak var newDot: WSColoredDot!
    var threadID: Int?
    var currentUserUID: Int {
        let defaults = NSUserDefaults.standardUserDefaults()
        return defaults.integerForKey(defaults_key_uid)
    }
        
    override func awakeFromNib() {
        super.awakeFromNib()
        newDot.color = WSColor.Blue
        newDot.setNeedsDisplay()
    }
    
    // Configures the cell for a given message thread
    // If the input is nil the cell labels are cleared
    //
    func configureWithMessageThread(messageThread: CDWSMessageThread?) {
        
        guard let messageThread = messageThread else {
            participantsLabel.text = nil
            dateLabel.text = nil
            subjectLabel.text = nil
            bodyPreviewLabel.text = nil
            newDot.hidden = true
            threadID = nil
            return
        }

        participantsLabel.text = messageThread.getParticipantString(currentUserUID)
        setDate(messageThread.last_updated)
        subjectLabel.text = messageThread.subject
        
        if messageThread.is_new != 0 {
            newDot.hidden = false
        } else {
            newDot.hidden = true
        }
        
        if let latest = messageThread.lastestMessage() {
            // set the body preview
            if var preview = latest.body {
                preview += "\n"
                // TODO remove blank lines from the message body so the preview doens't display blanks
                bodyPreviewLabel.text = preview
            }
        } else {
            bodyPreviewLabel.text = ""
        }
        
        threadID = messageThread.thread_id?.integerValue
    }
    
    func setDate(date: NSDate?) {
        if date != nil {
        let formatter = NSDateFormatter()
        let template = "dd/MM/yy"
        let locale = NSLocale.currentLocale()
        formatter.dateFormat = NSDateFormatter.dateFormatFromTemplate(template, options: 0, locale: locale)
        dateLabel.text = formatter.stringFromDate(date!)
        }
    }

}
