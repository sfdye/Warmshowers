//
//  ComposeMessageViewController+Navigation.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 13/07/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

extension ComposeMessageViewController {
    
    @IBAction func cancelButtonPressed(_ sender: AnyObject?) {
        
        // Show a warning message if the message body has some content
        guard body == nil || body ?? "" == "" else {
            let message = NSLocalizedString("Are you sure you want to discard the current message?", tableName: "Compose", comment: "Alert message shown when when the user navigates away from a draft message")
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
            return
        }
        
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
}
