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
    
    override func awakeFromNib() {
        
        // Phone icon tap gesture
        let phoneIconTap = UITapGestureRecognizer(target: self, action: Selector("phoneIconTapped"))
        phoneIconTap.numberOfTapsRequired = 1
        phoneIcon.userInteractionEnabled = true
        phoneIcon.addGestureRecognizer(phoneIconTap)
        
        // Message icon tap gesture
        let messageIconTap = UITapGestureRecognizer(target: self, action: Selector("messageIconTapped"))
        messageIconTap.numberOfTapsRequired = 1
        messageIcon.userInteractionEnabled = true
        messageIcon.addGestureRecognizer(messageIconTap)
    }
    
    // Configures the table view cell for a given phone number object
    func setWithPhoneNumber(phoneNumber: WSPhoneNumber) {
        phoneNumberLabel.text = phoneNumber.number
        numberTypeLabel.text = phoneNumber.description
        
        // TODO: link phone numbers to phone app and show icons below
        switch phoneNumber.type {
        case .Home, .Work:
            phoneIcon.hidden = false
            messageIcon.hidden = true
        case .Mobile:
            phoneIcon.hidden = false
            messageIcon.hidden = false
        }
    }
    
    func phoneIconTapped() {
        
        guard let url = phoneNumberURL(phoneNumberLabel.text) else {
            return
        }
        
        UIApplication.sharedApplication().openURL(url)
    }
    
    func messageIconTapped() {
        
        guard let url = messageNumberURL(phoneNumberLabel.text) else {
            return
        }
        
        UIApplication.sharedApplication().openURL(url)
    }
    
    // Returns the url to call the the phone number displayed in the cell
    //
    func phoneNumberURL(number: String?) -> NSURL? {
        
        guard let number = phoneNumberLabel.text else {
            return nil
        }
        
        return NSURL(string: "tel://" + number)
    }
    
    // Returns the url to message the the phone number displayed in the cell
    //
    func messageNumberURL(number: String?) -> NSURL? {
        
        guard let number = phoneNumberLabel.text else {
            return nil
        }
        
        return NSURL(string: "sms:" + number)
    }

}
