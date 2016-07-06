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
    func configureForTypeWithFeedback(_ feedback: WSRecommendation) {
        textLabel?.text = "Feedback for"
        detailTextLabel?.text = feedback.type.rawValue
    }
    
    // Configures the picker for feedback ratings
    //
    func configureForRatingWithFeedback(_ feedback: WSRecommendation) {
        textLabel?.text = "Overall experiencer"
        detailTextLabel?.text = feedback.rating.rawValue
    }
    
    // Configures the picker for feedback dates
    //
    func configureForDateWithFeedback(_ feedback: WSRecommendation) {
        let formatter = DateFormatter()
        let template = "MMMyyyy"
        let locale = Locale.current()
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: template, options: 0, locale: locale)
        textLabel?.text = "Date we met"
        detailTextLabel?.text = formatter.string(from: feedback.date as Date)
    }

}
