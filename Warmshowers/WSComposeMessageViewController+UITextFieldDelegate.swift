//
//  WSComposeMessageViewController+UITextFieldDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 12/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

extension WSComposeMessageViewController : UITextFieldDelegate {
    
    func textFieldDidEndEditing(textField: UITextField) {
        subject = textField.text
    }
    
}
