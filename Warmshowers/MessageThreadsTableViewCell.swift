//
//  MessageThreadTableViewCell.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 1/12/15.
//  Copyright © 2015 Rajan Fernandez. All rights reserved.
//

import UIKit

class MessageThreadsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var participantsLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var bodyPreviewLabel: UILabel!
    @IBOutlet weak var newDot: WSColoredDot!
    var threadID: Int?

    override func awakeFromNib() {
        super.awakeFromNib()
        newDot.color = WSColor.Blue
        newDot.setNeedsDisplay()
    }
    
}
