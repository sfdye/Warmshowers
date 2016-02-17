//
//  AvailiblityTableViewCell.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 1/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

class AvailabilityTableViewCell: UITableViewCell {

    func configureAsCurrentlyAvailable(userInfo: AnyObject?) {
        
        textLabel?.text = ""
        
        guard let userInfo = userInfo else {
            return
        }
        
        guard let notavailible = userInfo.valueForKey("notcurrentlyavailable")?.boolValue else {
            return
        }
        
        
        if notavailible {
            textLabel?.text = "Unavailable"
            self.backgroundColor = WSColor.NotAvailable
        } else {
            textLabel?.text = "Currently Available"
            self.backgroundColor = WSColor.Available
        }
    }
    
}
