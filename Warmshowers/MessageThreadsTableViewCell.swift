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
    
    // TODO: This logic should not be in the view. Move it to the controller.
    var currentUserUID: Int? { return WSSessionState.sharedSessionState.uid }
        
    override func awakeFromNib() {
        super.awakeFromNib()
        newDot.color = WSColor.Blue
        newDot.setNeedsDisplay()
    }
    
    // Configures the cell for a given message thread
    // If the input is nil the cell labels are cleared
    //
    func configureWithMessageThread(_ messageThread: CDWSMessageThread?) {
        
        guard let messageThread = messageThread else {
            participantsLabel.text = nil
            dateLabel.text = nil
            subjectLabel.text = nil
            bodyPreviewLabel.text = nil
            newDot.isHidden = true
            threadID = nil
            return
        }
        
        participantsLabel.text = messageThread.getParticipantString(currentUserUID)
        setDate(messageThread.last_updated)
        subjectLabel.text = messageThread.subject ?? ""
        newDot.isHidden = (messageThread.is_new == 0)
        bodyPreviewLabel.text = messageThread.lastestMessagePreview() ?? "\n"
        threadID = messageThread.thread_id?.intValue
    }
    
    func setDate(_ date: Date?) {
        if date != nil {
            let formatter = DateFormatter()
            let template = "dd/MM/yy"
            let locale = Locale.current()
            formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: template, options: 0, locale: locale)
            dateLabel.text = formatter.string(from: date!)
        } else {
            dateLabel.text = ""
        }
    }

}
