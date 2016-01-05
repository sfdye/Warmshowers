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
    
    func configureWithMessage(message: CDWSMessage) {
        setAuthor(message)
        setDate(message.timestamp)
        bodyTextView.text = message.body
        setAuthorImage(message.authorThumbnail)
    }
    
    func setAuthor(message: CDWSMessage) {
        if let name = message.authorName {
            fromLabel.text = name
        } else {
            fromLabel.text = ""
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
    
    func setAuthorImage(image: UIImage?) {
        guard let image = image else {
            return
        }
        authorImageView.image = image
    }
}
