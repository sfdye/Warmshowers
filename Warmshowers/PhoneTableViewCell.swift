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
    func setWithPhoneNumber(phoneNumber: PhoneNumber) {
        phoneNumberLabel.text = phoneNumber.number
        numberTypeLabel.text = phoneNumber.description
        switch phoneNumber.type {
        case .Home, .Work:
            phoneIcon.hidden = false
            messageIcon.hidden = true
        case .Mobile:
            phoneIcon.hidden = false
            messageIcon.hidden = false
        }
    }

}
