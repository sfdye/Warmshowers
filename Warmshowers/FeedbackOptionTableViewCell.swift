//
//  FeedbackOptionTableViewCell.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 10/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

class FeedbackOptionTableViewCell: UITableViewCell {
    
    // Configures the picker for feedback type
    //
    func configureForTypeWithFeedback(feedback: WSRecommendation) {
        textLabel?.text = "Feedback for"
        detailTextLabel?.text = feedback.recommendationFor.rawValue
    }
    
    // Configures the picker for feedback ratings
    //
    func configureForRatingWithFeedback(feedback: WSRecommendation) {
        textLabel?.text = "Overall experiencer"
        detailTextLabel?.text = feedback.rating.rawValue
    }
    
    // Configures the picker for feedback dates
    //
    func configureForDateWithFeedback(feedback: WSRecommendation) {
        let formatter = NSDateFormatter()
        let template = "MMMyyyy"
        let locale = NSLocale.currentLocale()
        formatter.dateFormat = NSDateFormatter.dateFormatFromTemplate(template, options: 0, locale: locale)
        textLabel?.text = "Date we met"
        detailTextLabel?.text = formatter.stringFromDate(feedback.date)
    }

}
