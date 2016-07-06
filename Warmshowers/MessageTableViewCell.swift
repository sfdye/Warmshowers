//
//  MessageTableViewCell.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 4/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {
    
    @IBOutlet var fromLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var bodyTextView: UITextView!
    @IBOutlet var authorImageView: UIImageView!
    
    func configureWithMessage(_ message: CDWSMessage) {
        fromLabel.text = message.authorName ?? ""
        setDate(message.timestamp)
        bodyTextView.text = message.body
        authorImageView.image = message.authorThumbnail ?? UIImage(named: "ThumbnailPlaceholder")
    }

    func setDate(_ date: Date?) {
        if date != nil {
            let formatter = DateFormatter()
            let template = "HHmmddMMMyyyy"
            let locale = Locale.current()
            formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: template, options: 0, locale: locale)
            dateLabel.text = formatter.string(from: date!)
        }
    }

}
