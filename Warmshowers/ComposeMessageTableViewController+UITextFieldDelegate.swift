//
//  ComposeMessageTableViewController+UITextFieldDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 12/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

extension ComposeMessageTableViewController : UITextFieldDelegate {
    
    func textFieldDidEndEditing(textField: UITextField) {
        message?.thread?.subject = textField.text
    }
    
}
