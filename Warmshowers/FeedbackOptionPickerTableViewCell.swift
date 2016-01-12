//
//  FeedbackOptionPickerTableViewCell.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 7/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

class FeedbackOptionPickerTableViewCell: UITableViewCell {
    
    @IBOutlet var picker: UIPickerView!
    
    // Configures the picker for feedback type
    //
    func configureForTypeWithFeedback(feedback: WSRecommendation) {
        let row = feedback.recommendationFor.hashValue
        picker.selectRow(row, inComponent: 0, animated: false)
    }
    
    // Configures the picker for feedback ratings
    //
    func configureForRatingWithFeedback(feedback: WSRecommendation) {
        let row = feedback.rating.hashValue
        picker.selectRow(row, inComponent: 0, animated: false)
    }
    
    // Configures the picker for feedback dates
    //
    func configureForDateWithFeedback(feedback: WSRecommendation) {
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        let dateComps = calendar!.components([.Month, .Year], fromDate: feedback.date)
        let yearSince2008 = dateComps.year - 2008
        picker.selectRow(dateComps.month - 1, inComponent: 0, animated: false)
        picker.selectRow(yearSince2008, inComponent: 1, animated: false)
    }
    
}
