//
//  PhoneTableViewCell.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 1/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

class PhoneTableViewCell: UITableViewCell {
    
    @IBOutlet var phoneNumberLabel: UILabel!
    @IBOutlet var numberTypeLabel: UILabel!
    @IBOutlet var phoneIcon: UIImageView!
    @IBOutlet var messageIcon: UIImageView!
    
    // Configures the table view cell for a given phone number object
    func setWithPhoneNumber(phoneNumber: WSPhoneNumber) {
        phoneNumberLabel.text = phoneNumber.number
        numberTypeLabel.text = phoneNumber.description
        
        // TODO: link phone numbers to phone app and show icons below
        switch phoneNumber.type {
        case .Home, .Work:
            phoneIcon.hidden = true //false
            messageIcon.hidden = true
        case .Mobile:
            phoneIcon.hidden = true //false
            messageIcon.hidden = true //false
        }
    }

}
