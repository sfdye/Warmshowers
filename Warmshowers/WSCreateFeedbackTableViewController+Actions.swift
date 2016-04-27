//
//  WSCreateFeedbackTableViewController+Actions.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 27/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

extension WSCreateFeedbackTableViewController {
    
    @IBAction func cancelButtonPressed(sender: AnyObject?) {
        
        self.view.endEditing(true)
        
        if feedback.hasBody {
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
        
        guard feedback.hasBody else {
            let alert = UIAlertController(title: "No feedback to submit", message: "Please enter some feedback before submitting.", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
            alert.addAction(okAction)
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        // Submit the feedback
        WSProgressHUD.show("Submitting feedback ...")
        apiCommunicator?.createFeedback(feedback, andNotify: self)
    }
}