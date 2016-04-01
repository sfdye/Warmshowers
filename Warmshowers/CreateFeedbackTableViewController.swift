//
//  ProvideFeedbackTableViewController.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 7/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit
import MBProgressHUD

let FEEDBACK_OPTION_CELL_ID = "FeedbackOption"
let FEEDBACK_OPTION_PICKER_CELL_ID = "FeedbackOptionPicker"
let FEEDBACK_DATE_PICKER_CELL_ID = "FeedbackDatePicker"
let FEEDBACK_BODY_CELL_ID = "FeedbackBody"

class CreateFeedbackTableViewController: UITableViewController {
    
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
    
    // View variables
    var pickerIndexPath: NSIndexPath? = nil
    let PlaceholderFeedback = "Type your feedback here."
    
    // HTTP Request client
    

    
    // MARK: View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // get the current year
        thisYear = calendar?.components([.Year], fromDate: NSDate()).year
        
        // Configure the table view
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return pickerIndexPath == nil ? 3 : 4
        default:
            return 1
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Feedback options section
        if indexPath.section == 0 {
            
            // if we have a date picker open whose cell is above the cell we want to update,
            // then we have one more cell than the model allows, so decrement the modelRow index
            var modelRow = indexPath.row
            if let pickerIndexPath = pickerIndexPath where pickerIndexPath.row <= indexPath.row {
                modelRow -= 1
            }
            
            // configure a picker cell
            if let pickerIndexPath = pickerIndexPath where pickerIndexPath.row == indexPath.row {
                let cell = tableView.dequeueReusableCellWithIdentifier(FEEDBACK_OPTION_PICKER_CELL_ID, forIndexPath: indexPath) as! FeedbackOptionPickerTableViewCell
                cell.picker.delegate = self
                cell.picker.dataSource = self
                switch modelRow {
                case 0:
                    // Feedback guest or host picker
                    cell.configureForTypeWithFeedback(feedback)
                case 1:
                    // Feedback rating picker
                    cell.configureForRatingWithFeedback(feedback)
                default:
                    // Feedback date picker
                    cell.configureForDateWithFeedback(feedback)
                }
                return cell
            }

            // configure a option cell
            let cell = tableView.dequeueReusableCellWithIdentifier(FEEDBACK_OPTION_CELL_ID, forIndexPath: indexPath) as! FeedbackOptionTableViewCell
            switch modelRow {
            case 0:
                // Feedback guest or host picker
                cell.configureForTypeWithFeedback(feedback)
            case 1:
                // Feedback rating picker
                cell.configureForRatingWithFeedback(feedback)
            default:
                // Feedback date picker
                cell.configureForDateWithFeedback(feedback)
            }
            return cell
            
        } else {
            
            // Written feedback section
            let cell = tableView.dequeueReusableCellWithIdentifier(FEEDBACK_BODY_CELL_ID, forIndexPath: indexPath) as! FeedbackBodyTableViewCell
            cell.textView.delegate = self
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 0 {
            
            hideKeyboard()
            
            // show a picker
            let cell = tableView.cellForRowAtIndexPath(indexPath)
            if cell?.reuseIdentifier == FEEDBACK_OPTION_CELL_ID {
                displayInlinePickerForRowAtIndexPath(indexPath)
            } else {
                tableView.deselectRowAtIndexPath(indexPath, animated: true)
            }
        } else {
            
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            removeAllPickerCells()
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Options"
        case 1:
            return "Feedback"
        default:
            return ""
        }
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
        
        guard let userName = userName else {
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
        let feedbackSender = WSFeedbackSender(
            feedback: feedback,
            userName: userName,
            success: { () -> Void in
                // Dismiss the view on successful feedback submission
                WSProgressHUD.hide()
                self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
            },
            failure: {(error) -> Void in
                // Show an error
                WSProgressHUD.hide()
                let alert = UIAlertController(title: "Could not submit feedback", message: "Sorry, an error occured while submitted your feedback. Please check you are connected to the internet and try again later.", preferredStyle: .Alert)
                let okAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
                alert.addAction(okAction)
                self.presentViewController(alert, animated: true, completion: nil)
            }
        )
        WSProgressHUD.show("Submitting feedback ...")
        feedbackSender.send()
    }

}
