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
        let phoneIconTap = UITapGestureRecognizer(target: self, action: #selector(ContactTableViewCell.phoneIconTapped))
        phoneIconTap.numberOfTapsRequired = 1
        phoneIcon.isUserInteractionEnabled = true
        phoneIcon.addGestureRecognizer(phoneIconTap)
        
        // Message icon tap gesture
        let messageIconTap = UITapGestureRecognizer(target: self, action: #selector(ContactTableViewCell.messageIconTapped))
        messageIconTap.numberOfTapsRequired = 1
        messageIcon.isUserInteractionEnabled = true
        messageIcon.addGestureRecognizer(messageIconTap)
    }
    
    // Configures the table view cell for a phone number
    //
    func setWithPhoneNumber(_ phoneNumber: WSPhoneNumber) {
        titleLabel.text = phoneNumber.description
        detailLabel.text = phoneNumber.number
        
        switch phoneNumber.type {
        case .home, .work:
            phoneIcon.isHidden = false
            messageIcon.isHidden = true
        case .mobile:
            phoneIcon.isHidden = false
            messageIcon.isHidden = false
        }
    }
    
    // Configures the table view cell for an address
    //
    func setWithAddress(_ address: String) {
        titleLabel.text = "Address"
        detailLabel.numberOfLines = 0
        detailLabel.text = address
        phoneIcon.isHidden = true
        messageIcon.isHidden = true
    }
    
    // Called when the user taps the phone icon
    //
    func phoneIconTapped() {
        
        guard let url = phoneNumberURL(detailLabel.text) else {
            return
        }
        
        UIApplication.shared().openURL(url)
    }
    
    // Called when the user taps the message bubble icon
    //
    func messageIconTapped() {
        
        guard let url = messageNumberURL(detailLabel.text) else {
            return
        }
        
        UIApplication.shared().openURL(url)
    }
    
    // Returns the url to call the the phone number displayed in the cell
    //
    func phoneNumberURL(_ number: String?) -> URL? {
        
        guard let number = detailLabel.text else {
            return nil
        }
        
        return URL(string: "tel://" + number)
    }
    
    // Returns the url to message the the phone number displayed in the cell
    //
    func messageNumberURL(_ number: String?) -> URL? {
        
        guard let number = detailLabel.text else {
            return nil
        }
        
        return URL(string: "sms:" + number)
    }

}
