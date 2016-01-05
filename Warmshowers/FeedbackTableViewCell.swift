//
//  FeedbackTableViewCell.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 3/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

class FeedbackTableViewCell: UITableViewCell {
    
    @IBOutlet var authorImage: UIImageView!
    @IBOutlet var authorNameLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var ratingLabel: UILabel!
    @IBOutlet var bodyLabel: UILabel!
    let formatter = NSDateFormatter()
    
    func configureWithFeedback(feedback: WSRecommendation) {
        setAuthorThumbnailImage(feedback.authorImage)
        authorNameLabel.text = feedback.author.fullname
        setDate(feedback.date)
        setRating(feedback.rating)
        bodyLabel.text = feedback.body
    }
    
    func setAuthorThumbnailImage(image: UIImage?) {
        
        guard image != nil else {
            return
        }
        
        self.authorImage.image = image!
    }
    
    func setDate(date: NSDate) {
        let formatter = NSDateFormatter()
        let template = "ddMMMyyyy"
        let locale = NSLocale.currentLocale()
        formatter.dateFormat = NSDateFormatter.dateFormatFromTemplate(template, options: 0, locale: locale)
        dateLabel.text = formatter.stringFromDate(date)
    }
    
    func setRating(rating: WSRecommendationRating) {
        ratingLabel.text = rating.asString()
        switch rating {
        case .Positive:
            ratingLabel.textColor = WSCOLOR_GREEN
        case .Negative:
            ratingLabel.textColor = WSCOLOR_RED
        case .Neutral:
            ratingLabel.textColor = WSCOLOR_ORANGE
        }
    }
    
}
