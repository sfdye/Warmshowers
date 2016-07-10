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
        backgroundColor = UIColor.grayColor()
    }
    
    func configureAsAvailable() {
        textLabel?.text = "Currently Available"
        backgroundColor = WSColor.Available
    }
    
    func configureAsNotAvailable() {
        textLabel?.text = "Unavailable"
        backgroundColor = WSColor.NotAvailable
    }
    
}
