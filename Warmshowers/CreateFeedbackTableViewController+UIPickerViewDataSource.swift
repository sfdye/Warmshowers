//
//  +UIPickerViewDataSource.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 8/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

extension CreateFeedbackTableViewController : UIPickerViewDataSource {
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        
        guard let pickerRow = pickerIndexPath?.row else {
            return 0
        }
        
        switch pickerRow - 1 {
        case 2:
            // Month and year components in the date picker
            return 2
        default:
            // All other pickers only have one component
            return 1
        }
    }

    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        guard let pickerRow = pickerIndexPath?.row else {
            return 0
        }
        
        switch pickerRow - 1 {
        case 0:
            return WSRecommendationFor.allValues.count
        case 1:
            return WSRecommendationRating.allValues.count
        case 2:
            switch component {
            case 0:
                return 12
            case 1:
                // Return the number of years since 2008 (including 2008)
                return thisYear! - BaseYear + 1
            default:
                return 0
            }
        default:
            return 0
        }
    }
    
}