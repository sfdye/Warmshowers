//
//  AvailiblityTableViewCell.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 1/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

class AvailiblityTableViewCell: UITableViewCell {
    
    let WSCOLOR_AVAILIBLE_GREEN = UIColor(red: 1/255, green: 158/255, blue: 60/255, alpha: 1)
    let WSCOLOR_NOT_AVAILIBLE_RED = UIColor.redColor()

    func configureAsCurrentlyAvailible(userInfo: AnyObject?) {
        
        textLabel?.text = ""
        
        guard let userInfo = userInfo else {
            return
        }
        
        guard let notavailible = userInfo.valueForKey("notcurrentlyavailable")?.boolValue else {
            return
        }
        
        
        if notavailible {
            textLabel?.text = "Unavailible"
            self.backgroundColor = WSCOLOR_NOT_AVAILIBLE_RED
        } else {
            textLabel?.text = "Currently Availible"
            self.backgroundColor = WSCOLOR_AVAILIBLE_GREEN
        }
    }
    
}
