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
    @IBOutlet weak var newDot: WSColoredDot!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        newDot.color = WSColor.Blue
        newDot.setNeedsDisplay()
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
