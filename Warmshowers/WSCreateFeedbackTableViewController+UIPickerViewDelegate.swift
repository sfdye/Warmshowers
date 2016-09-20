//
//  WSCreateFeedbackTableViewController+PickerViewDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 7/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

extension WSCreateFeedbackTableViewController : UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        guard let pickerRow = (pickerIndexPath as NSIndexPath?)?.row else {
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
            recommendation.type.setFromRawValue(selectedValue)
        case 1:
            // Feedback rating picker
            recommendation.rating.setFromRawValue(selectedValue)
        case 2:
            // Feedback date picker
            var comps = calendar.dateComponents([.month, .year], from: recommendation.date as Date)
            switch component {
            case 0:
                comps.month = row + 1
            case 1:
                comps.year = BaseYear + row
            default:
                break
            }
            if let date = calendar.date(from: comps) {
                recommendation.date = date
            }
            
        default:
            return
        }
        
        tableView.reloadRows(at: [IndexPath(row: optionCellRow, section: 0)], with: .none)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        guard let modelRow = (pickerIndexPath as NSIndexPath?)?.row else {
            return nil
        }
        
        switch modelRow - 1 {
        case 0:
            // Feedback guest or host picker
            return WSRecommendationType.allValues[row].rawValue
        case 1:
            // Feedback rating picker
            return WSRecommendationRating.allValues[row].rawValue
        case 2:
            // Feedback date picker
            switch component {
            case 0:
                var dateComps = DateComponents()
                dateComps.month = row + 1
                let date = calendar.date(from: dateComps)
                formatter.dateFormat = monthFormat
                return formatter.string(from: date!)
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
