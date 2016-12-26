//
//  CreateFeedbackTableViewController+UITableViewDataSource.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 21/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

extension CreateFeedbackTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return pickerIndexPath == nil ? 3 : 4
        default:
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Feedback options section
        if (indexPath as NSIndexPath).section == 0 {
            
            // if we have a date picker open whose cell is above the cell we want to update,
            // then we have one more cell than the model allows, so decrement the modelRow index
            var modelRow = (indexPath as NSIndexPath).row
            if let pickerIndexPath = pickerIndexPath , (pickerIndexPath as NSIndexPath).row <= (indexPath as NSIndexPath).row {
                modelRow -= 1
            }
            
            // configure a picker cell
            if let pickerIndexPath = pickerIndexPath , (pickerIndexPath as NSIndexPath).row == (indexPath as NSIndexPath).row {
                let cell = tableView.dequeueReusableCell(withIdentifier: "FeedbackOptionPicker", for: indexPath) as! FeedbackOptionPickerTableViewCell
                cell.picker.delegate = self
                cell.picker.dataSource = self
                switch modelRow {
                case 0:
                    // Feedback guest or host picker
                    cell.configureForTypeWithFeedback(recommendation)
                case 1:
                    // Feedback rating picker
                    cell.configureForRatingWithFeedback(recommendation)
                default:
                    // Feedback date picker
                    cell.configureForDateWithFeedback(recommendation)
                }
                return cell
            }
            
            // configure a option cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "FeedbackOption", for: indexPath) as! FeedbackOptionTableViewCell
            switch modelRow {
            case 0:
                // Feedback guest or host picker
                cell.configureForTypeWithFeedback(recommendation)
            case 1:
                // Feedback rating picker
                cell.configureForRatingWithFeedback(recommendation)
            default:
                // Feedback date picker
                cell.configureForDateWithFeedback(recommendation)
            }
            return cell
            
        } else {
            
            // Written feedback section
            let cell = tableView.dequeueReusableCell(withIdentifier: "FeedbackBody", for: indexPath) as! FeedbackBodyTableViewCell
            cell.textView.delegate = self
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Options"
        case 1:
            return "Feedback"
        default:
            return ""
        }
    }
}
