//
//  CreateFeedbackTableViewController.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 7/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit
import MBProgressHUD
import WarmshowersData

let SBID_CreateFeedback = "CreateFeedback"

class CreateFeedbackTableViewController: UITableViewController, Delegator, DataSource {
    
    // MARK: Properties
    
    // Feedback date
    let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
    let BaseYear = 2008
    var thisYear: Int?
    let formatter = DateFormatter()
    let monthFormat = DateFormatter.dateFormat(fromTemplate: "MMMM", options: 0, locale: Locale.current)
    let yearTemplate = DateFormatter.dateFormat(fromTemplate: "yyyy", options: 0, locale: Locale.current)
    
    // Feedback model
    var recommendation = Recommendation()
    var userName: String?
    
    // View state variables
    var pickerIndexPath: IndexPath? = nil
    let PlaceholderFeedback = NSLocalizedString("Type your feedback here.", comment: "Feedback text field place holder")
    
    
    // MARK: View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get the current year
        thisYear = (calendar as NSCalendar?)?.components([.year], from: Date()).year
        
        // Configure the table view
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
    }
    
    
    // MARK: Configuration
    
    // Configures the view controller
    func configureForSendingFeedbackForUserWithUserName(_ userName: String?) {
        recommendation.recommendedUserName = userName
    }
    
   
    // MARK: Utility methods
    
    // Checks if a picker is at the given index path
    //
    func hasPickerAtIndexPath(_ indexPath: IndexPath) -> Bool {
        if let pickerIndexPath = pickerIndexPath , (pickerIndexPath as NSIndexPath).row == (indexPath as NSIndexPath).row {
            return true
        } else {
            return false
        }
    }
    
    // Displays an inline picker for a given index path
    func displayInlinePickerForRowAtIndexPath(_ indexPath: IndexPath) {
        
        guard (indexPath as NSIndexPath).section == 0 else {
            return
        }
        
        tableView.beginUpdates()
        
        var before = false
        var sameCellClicked = false
        if let pickerIndexPath = pickerIndexPath {
            
            // Find if the picker is before the index path
            before = (pickerIndexPath as NSIndexPath).row < (indexPath as NSIndexPath).row
            
            // Find the option cell with a pick was tapped
            sameCellClicked = ((pickerIndexPath as NSIndexPath).row - 1) == (indexPath as NSIndexPath).row
            
            // Remove any picker cell that exists
            tableView.deleteRows(at: [pickerIndexPath], with: UITableViewRowAnimation.automatic)
            self.pickerIndexPath = nil
        }
        
        // Show a new picker
        if !sameCellClicked {
            
            // Display the new picker
            let rowToReveal = before ? (indexPath as NSIndexPath).row - 1 : (indexPath as NSIndexPath).row
            let indexPathToReveal = IndexPath(row: rowToReveal, section: 0)
            showPickerForIndexPath(indexPathToReveal)
            pickerIndexPath = IndexPath(row: (indexPathToReveal as NSIndexPath).row + 1, section: 0)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.endUpdates()
    }
    
    // Inserts a picker cell under the cell at the given index path
    //
    func showPickerForIndexPath(_ indexPath: IndexPath) {
        tableView.beginUpdates()
        let pickerIndexPath = IndexPath(row: (indexPath as NSIndexPath).row + 1, section: (indexPath as NSIndexPath).section)
        tableView.insertRows(at: [pickerIndexPath], with: UITableViewRowAnimation.automatic)
        tableView.endUpdates()
    }
    
    // Removes all picker cell from the table view
    //
    func removeAllPickerCells() {
        if let pickerIndexPath = pickerIndexPath {
            tableView.beginUpdates()
            tableView.deleteRows(at: [pickerIndexPath], with: UITableViewRowAnimation.automatic)
            self.pickerIndexPath = nil
            tableView.endUpdates()
        }
    }
    
    // Method to force hidding the keyboard
    //
    func hideKeyboard() {
        self.view.endEditing(true)
    }

}
