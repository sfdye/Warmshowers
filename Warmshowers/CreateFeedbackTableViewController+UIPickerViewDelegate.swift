//
//  CreateFeedbackTableViewController+PickerViewDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 7/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

extension CreateFeedbackTableViewController : UIPickerViewDelegate {
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        guard let pickerRow = pickerIndexPath?.row else {
            return
        }
        
        guard let selectedValue = self.pickerView(pickerView, titleForRow: row, forComponent: component) else {
            return
        }
        
        let optionCellRow = pickerRow - 1
        
        // Update the model
        switch optionCellRow {
        case 0:
            // Feedback guest or host picker
            feedback.recommendationFor.setFromRawValue(selectedValue)
        case 1:
            // Feedback rating picker
            feedback.rating.setFromRawValue(selectedValue)
        case 2:
            // Feedback date picker
            if let comps = calendar?.components([.Month, .Year], fromDate: feedback.date) {
                switch component {
                case 0:
                    comps.month = row + 1
                case 1:
                    comps.year = BaseYear + row
                default:
                    break
                }
                if let date = calendar?.dateFromComponents(comps) {
                    feedback.date = date
                }
            }
            
        default:
            return
        }
        
        tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: optionCellRow, inSection: 0)], withRowAnimation: .None)
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        guard let modelRow = pickerIndexPath?.row else {
            return nil
        }
        
        switch modelRow - 1 {
        case 0:
            // Feedback guest or host picker
            return WSRecommendationFor.allValues[row].rawValue
        case 1:
            // Feedback rating picker
            return WSRecommendationRating.allValues[row].rawValue
        case 2:
            // Feedback date picker
            switch component {
            case 0:
                let dateComps = NSDateComponents()
                dateComps.month = row + 1
                let date = calendar?.dateFromComponents(dateComps)
                formatter.dateFormat = monthFormat
                return formatter.stringFromDate(date!)
            case 1:
                return String(BaseYear + row)
            default:
                return nil
            }
        default:
            return nil
        }
    }
    
}
