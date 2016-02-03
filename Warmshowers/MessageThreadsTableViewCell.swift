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
        subjectLabel.text = messageThread.subject ?? ""
        newDot.hidden = (messageThread.is_new == 0)
        bodyPreviewLabel.text = messageThread.lastestMessagePreview()
        threadID = messageThread.thread_id?.integerValue
    }
    
    func setDate(date: NSDate?) {
        if date != nil {
            let formatter = NSDateFormatter()
            let template = "dd/MM/yy"
            let locale = NSLocale.currentLocale()
            formatter.dateFormat = NSDateFormatter.dateFormatFromTemplate(template, options: 0, locale: locale)
            dateLabel.text = formatter.stringFromDate(date!)
        } else {
            dateLabel.text = ""
        }
    }

}
