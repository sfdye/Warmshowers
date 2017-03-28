//
//  AvailiblityTableViewCell.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 1/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

class AvailabilityTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        textLabel?.text = ""
        backgroundColor = UIColor.gray
    }
    
    func configureAsAvailable() {
        textLabel?.text = NSLocalizedString("Currently Available", comment: "Currently availible message")
        backgroundColor = WarmShowersColor.Available
    }
    
    func configureAsNotAvailable() {
        textLabel?.text = NSLocalizedString("Unavailable", comment: "Currently not availible message")
        backgroundColor = WarmShowersColor.NotAvailable
    }
    
}
