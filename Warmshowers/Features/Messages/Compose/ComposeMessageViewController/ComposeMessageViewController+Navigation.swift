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
            let alert = UIAlertController(title: nil, message: "Are you sure you want to discard the current message?", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            let continueAction = UIAlertAction(title: "Continue", style: .default) { (continueAction) -> Void in
                self.navigationController?.dismiss(animated: true, completion: nil)
            }
            alert.addAction(continueAction)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
}
