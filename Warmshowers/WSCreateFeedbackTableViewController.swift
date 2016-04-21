//
//  WSCreateWSFeedbackTableViewController.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 7/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit
import MBProgressHUD

class WSCreateWSFeedbackTableViewController: UITableViewController {
    
    // MARK: Properties
    
    // Feedback date
    let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
    let BaseYear = 2008
    var thisYear: Int?
    let formatter = NSDateFormatter()
    let monthFormat = NSDateFormatter.dateFormatFromTemplate("MMMM", options: 0, locale: NSLocale.currentLocale())
    let yearTemplate = NSDateFormatter.dateFormatFromTemplate("yyyy", options: 0, locale: NSLocale.currentLocale())
    
    // Feedback model
    var feedback = WSRecommendation()
    var userName: String?
    
    // View state variables
    var pickerIndexPath: NSIndexPath? = nil
    let PlaceholderFeedback = "Type your feedback here."
    
    // HTTP client
    var apiCommunicator: WSAPICommunicatorProtocol?
    
    
    // MARK: View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        apiCommunicator = WSAPICommunicator.sharedAPICommunicator
        assert(apiCommunicator != nil, "WSCreateWSFeedbackTableViewController failed to set an API Communicator.")
        
        // Get the current year
        thisYear = calendar?.components([.Year], fromDate: NSDate()).year
        
        // Configure the table view
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
    }
    
   
    // MARK: Utility methods
    
    // Configures the view controller
    func configureForSendingFeedbackForUserWithUserName(userName: String?) {
        feedback.recommendedUserName = userName
    }
    
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
        tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: indexPath.row + 1, inSection: indexPath.section)], withRowAnimation: UITableViewRowAnimation.Automatic)
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

    
    // MARK: Actions

    @IBAction func cancelButtonPressed(sender: AnyObject?) {
        
        self.view.endEditing(true)
        
        if feedback.body != "" {
            let alert = UIAlertController(title: nil, message: "Are you sure you want to discard the current feedback?", preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            alert.addAction(cancelAction)
            let continueAction = UIAlertAction(title: "Continue", style: .Default) { (continueAction) -> Void in
                self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
            }
            alert.addAction(continueAction)
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    @IBAction func sumbitButtonPressed(sender: AnyObject?) {
        
        self.view.endEditing(true)
        
        guard let _ = feedback.recommendedUserName else {
            let alert = UIAlertController(title: "An error occured", message: "Recommended user not set. Please report this as a bug, sorry for the inconvenience.", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
            alert.addAction(okAction)
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        guard feedback.body != "" else {
            let alert = UIAlertController(title: "No feedback to submit", message: "Please enter some feedback before submitting.", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
            alert.addAction(okAction)
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        // Submit the feedback
        apiCommunicator?.sendFeedback(feedback, andNotify: self)
        WSProgressHUD.show("Submitting feedback ...")
    }

}
