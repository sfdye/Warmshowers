//
//  ContactTableViewCell.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 1/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var detailLabel: UILabel!
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
    
    // Configures the table view cell for a phone number
    //
    func setWithPhoneNumber(phoneNumber: WSPhoneNumber) {
        titleLabel.text = phoneNumber.description
        detailLabel.text = phoneNumber.number
        
        switch phoneNumber.type {
        case .Home, .Work:
            phoneIcon.hidden = false
            messageIcon.hidden = true
        case .Mobile:
            phoneIcon.hidden = false
            messageIcon.hidden = false
        }
    }
    
    // Configures the table view cell for an address
    //
    func setWithAddress(address: String) {
        titleLabel.text = "Address"
        detailLabel.numberOfLines = 0
        detailLabel.text = address
        phoneIcon.hidden = true
        messageIcon.hidden = true
    }
    
    // Called when the user taps the phone icon
    //
    func phoneIconTapped() {
        
        guard let url = phoneNumberURL(detailLabel.text) else {
            return
        }
        
        UIApplication.sharedApplication().openURL(url)
    }
    
    // Called when the user taps the message bubble icon
    //
    func messageIconTapped() {
        
        guard let url = messageNumberURL(detailLabel.text) else {
            return
        }
        
        UIApplication.sharedApplication().openURL(url)
    }
    
    // Returns the url to call the the phone number displayed in the cell
    //
    func phoneNumberURL(number: String?) -> NSURL? {
        
        guard let number = detailLabel.text else {
            return nil
        }
        
        return NSURL(string: "tel://" + number)
    }
    
    // Returns the url to message the the phone number displayed in the cell
    //
    func messageNumberURL(number: String?) -> NSURL? {
        
        guard let number = detailLabel.text else {
            return nil
        }
        
        return NSURL(string: "sms:" + number)
    }

}
