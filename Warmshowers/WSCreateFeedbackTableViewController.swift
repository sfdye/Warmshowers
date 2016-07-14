//
//  WSCreateFeedbackTableViewController.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 7/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit
import MBProgressHUD

let SBID_CreateFeedback = "CreateFeedback"

class WSCreateFeedbackTableViewController: UITableViewController {
    
    // MARK: Properties
    
    // Feedback date
    let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
    let BaseYear = 2008
    var thisYear: Int?
    let formatter = NSDateFormatter()
    let monthFormat = NSDateFormatter.dateFormatFromTemplate("MMMM", options: 0, locale: NSLocale.currentLocale())
    let yearTemplate = NSDateFormatter.dateFormatFromTemplate("yyyy", options: 0, locale: NSLocale.currentLocale())
    
    // Feedback model
    var recommendation = WSRecommendation()
    var userName: String?
    
    // View state variables
    var pickerIndexPath: NSIndexPath? = nil
    let PlaceholderFeedback = "Type your feedback here."
    
    // Delegates
    var api: WSAPICommunicatorProtocol? = WSAPICommunicator.sharedAPICommunicator
    var alert: WSAlertProtocol? = WSAlertDelegate.sharedAlertDelegate
    
    
    // MARK: View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get the current year
        thisYear = calendar?.components([.Year], fromDate: NSDate()).year
        
        // Configure the table view
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
    }
    
    
    // MARK: Configuration
    
    // Configures the view controller
    func configureForSendingFeedbackForUserWithUserName(userName: String?) {
        recommendation.recommendedUserName = userName
    }
    
   
    // MARK: Utility methods
    
    // Checks if a picker is at the given index path
    //
    func hasPickerAtIndexPath(indexPath: NSIndexPath) -> Bool {
        if let pickerIndexPath = pickerIndexPath where pickerIndexPath.row == indexPath.row {
            return true
        } else {
            return false
        }
    }
    
    // Displays an inline picker for a given index path
    func displayInlinePickerForRowAtIndexPath(indexPath: NSIndexPath) {
        
        guard indexPath.section == 0 else {
            return
        }
        
        tableView.beginUpdates()
        
        var before = false
        var sameCellClicked = false
        if let pickerIndexPath = pickerIndexPath {
            
            // Find if the picker is before the index path
            before = pickerIndexPath.row < indexPath.row
            
            // Find the option cell with a pick was tapped
            sameCellClicked = (pickerIndexPath.row - 1) == indexPath.row
            
            // Remove any picker cell that exists
            tableView.deleteRowsAtIndexPaths([pickerIndexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            self.pickerIndexPath = nil
        }
        
        // Show a new picker
        if !sameCellClicked {
            
            // Display the new picker
            let rowToReveal = before ? indexPath.row - 1 : indexPath.row
            let indexPathToReveal = NSIndexPath(forRow: rowToReveal, inSection: 0)
            showPickerForIndexPath(indexPathToReveal)
            pickerIndexPath = NSIndexPath(forRow: indexPathToReveal.row + 1, inSection: 0)
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        tableView.endUpdates()
    }
    
    // Inserts a picker cell under the cell at the given index path
    //
    func showPickerForIndexPath(indexPath: NSIndexPath) {
        tableView.beginUpdates()
        let pickerIndexPath = NSIndexPath(forRow: indexPath.row + 1, inSection: indexPath.section)
        tableView.insertRowsAtIndexPaths([pickerIndexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        tableView.endUpdates()
    }
    
    // Removes all picker cell from the table view
    //
    func removeAllPickerCells() {
        if let pickerIndexPath = pickerIndexPath {
            tableView.beginUpdates()
            tableView.deleteRowsAtIndexPaths([pickerIndexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
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
