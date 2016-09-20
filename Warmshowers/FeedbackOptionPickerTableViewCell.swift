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
    func configureForTypeWithFeedback(_ feedback: WSRecommendation) {
        let row = feedback.type.hashValue
        picker.selectRow(row, inComponent: 0, animated: false)
    }
    
    // Configures the picker for feedback ratings
    //
    func configureForRatingWithFeedback(_ feedback: WSRecommendation) {
        let row = feedback.rating.hashValue
        picker.selectRow(row, inComponent: 0, animated: false)
    }
    
    // Configures the picker for feedback dates
    //
    func configureForDateWithFeedback(_ feedback: WSRecommendation) {
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        let dateComps = (calendar as NSCalendar).components([.month, .year], from: feedback.date as Date)
        let yearSince2008 = dateComps.year! - 2008
        picker.selectRow(dateComps.month! - 1, inComponent: 0, animated: false)
        picker.selectRow(yearSince2008, inComponent: 1, animated: false)
    }
    
}
