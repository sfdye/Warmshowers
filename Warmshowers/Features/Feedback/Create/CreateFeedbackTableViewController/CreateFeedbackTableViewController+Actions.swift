//
//  CreateFeedbackTableViewController+Actions.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 27/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

extension CreateFeedbackTableViewController {
    
    @IBAction func cancelButtonPressed(_ sender: AnyObject?) {
        
        self.view.endEditing(true)
        
        if recommendation.hasBody {
            let message = NSLocalizedString("Are you sure you want to discard the current feedback?", tableName: "CreateFeedback", comment: "Alert message for checking if the user wants to discard their drafted feedback")
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            
            let cancelButtonTitle = NSLocalizedString("Cancel", comment: "Cancel button title")
            let cancelAction = UIAlertAction(title: cancelButtonTitle, style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            
            let continueButtonTitle = NSLocalizedString("Continue", comment: "Continue button title")
            let continueAction = UIAlertAction(title: continueButtonTitle, style: .default) { (continueAction) -> Void in
                self.navigationController?.dismiss(animated: true, completion: nil)
            }
            alert.addAction(continueAction)
            self.present(alert, animated: true, completion: nil)
        } else {
            self.navigationController?.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func sumbitButtonPressed(_ sender: AnyObject?) {
        
        self.view.endEditing(true)
        
        guard let _ = recommendation.recommendedUserName else {
            let title = NSLocalizedString("Error", comment: "General error alert title")
            let button = NSLocalizedString("OK", comment: "OK button title")
            let message = NSLocalizedString("Recommended user not set. Please report this as a bug, sorry for the inconvenience.", tableName: "CreateFeedback", comment: "Alert message shown with the recommended user is not set. This should never occur")
            alert.presentAlertFor(self, withTitle: title, button: button, message: message)
            return
        }
        
        guard recommendation.hasBody else {
            let title = NSLocalizedString("No feedback to submit", tableName: "CreateFeedback", comment: "Alert title shown when the users tries to sumbit feedback before writing any")
            let button = NSLocalizedString("OK", comment: "OK button title")
            let message = NSLocalizedString("Please enter some feedback before submitting.", tableName: "CreateFeedback", comment: "Alert message shown when the users tries to sumbit feedback before writing any")
            alert.presentAlertFor(self, withTitle: title, button: button, message: message)
            return
        }
        
        // Submit the feedback
        let message = NSLocalizedString("Submitting feedback ...", tableName: "CreateFeedback", comment: "Label shown with the spinner while feedback is being submitted")
        ProgressHUD.show(navigationController?.view, label: message)
        api.contact(endPoint: .createFeedback, withMethod: .post, andPathParameters: nil, andData: recommendation, thenNotify: self, ignoreCache: false)
    }
}
