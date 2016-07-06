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
    @IBOutlet var forLabel: UILabel!
    @IBOutlet var bodyLabel: UILabel!
    let formatter = DateFormatter()
    
    func configureWithFeedback(_ feedback: WSRecommendation) {
//        setAuthorThumbnailImage(feedback.authorImage)
        authorNameLabel.text = feedback.author?.fullname
        setDate(feedback.date as Date)
        setRating(feedback.rating)
        setType(feedback.type)
        bodyLabel.text = feedback.body
    }
    
//    func setAuthorThumbnailImage(image: UIImage?) {
//        
//        guard image != nil else {
//            return
//        }
//        
//        self.authorImage.image = image!
//    }
    
    func setDate(_ date: Date) {
        let formatter = DateFormatter()
        let template = "ddMMMyyyy"
        let locale = Locale.current()
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: template, options: 0, locale: locale)
        dateLabel.text = formatter.string(from: date)
    }
    
    func setRating(_ rating: WSRecommendationRating) {
        ratingLabel.text = rating.rawValue
        switch rating {
        case .Positive:
            ratingLabel.textColor = WSColor.Positive
        case .Negative:
            ratingLabel.textColor = WSColor.Negative
        case .Neutral:
            ratingLabel.textColor = WSColor.Neutral
        }
    }
    
    func setType(_ type: WSRecommendationType) {
        switch type {
        case .ForGuest:
            forLabel.text = "Host, "
        case .ForHost:
            forLabel.text = "Guest, "
        default:
            forLabel.text = type.rawValue + ", "
        }
    }
}
