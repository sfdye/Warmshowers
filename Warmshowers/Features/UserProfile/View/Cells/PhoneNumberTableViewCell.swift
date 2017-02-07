//
//  ContactTableViewCell.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 1/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

class PhoneNumberTableViewCell: UITableViewCell {
    
    weak var delegate: PhoneNumberTableViewCellDelegate?
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var detailLabel: UILabel!
    @IBOutlet var phoneIcon: UIImageView!
    @IBOutlet var messageIcon: UIImageView!
    
    override func awakeFromNib() {
        
        // Phone icon tap gesture
        let phoneIconTap = UITapGestureRecognizer(target: self, action: #selector(PhoneNumberTableViewCell.phoneIconTapped))
        phoneIconTap.numberOfTapsRequired = 1
        phoneIcon.isUserInteractionEnabled = true
        phoneIcon.addGestureRecognizer(phoneIconTap)
        
        // Message icon tap gesture
        let messageIconTap = UITapGestureRecognizer(target: self, action: #selector(PhoneNumberTableViewCell.messageIconTapped))
        messageIconTap.numberOfTapsRequired = 1
        messageIcon.isUserInteractionEnabled = true
        messageIcon.addGestureRecognizer(messageIconTap)
    }
    
    /** Opens the phone app when the user taps the phone icon. */
    func phoneIconTapped() {
        delegate?.didSelectPhoneIcon(in: self)
    }
    
    /** Opens the messages app when the user taps the message bubble icon. */
    func messageIconTapped() {
        delegate?.didSelectMessageIcon(in: self)
    }

}
