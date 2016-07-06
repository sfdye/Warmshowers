//
//  AccountDetailsTableViewCell.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 27/12/15.
//  Copyright © 2015 Rajan Fernandez. All rights reserved.
//

import UIKit

class AccountDetailTableViewCell: UITableViewCell {
    
    @IBOutlet var label: UILabel!
    
    // Configures the cell to show
    func configureAsMemberFor(_ userInfo: AnyObject?) {
        
        label.text = "Member for"
        
        guard let userInfo = userInfo else {
            return
        }
        
        guard let created: TimeInterval = userInfo.value(forKey: "created")?.doubleValue else {
            return
        }
        
        let now = Date().timeIntervalSince1970
        let since = WSTimeInterval(timeInterval: now - created)
        label.text = "Member for " + since.asString()
    }
    
    // Configures the cell to show how long ago the user was last logged in
    //
    func configureAsActiveAgo(_ userInfo: AnyObject?) {
        
        label.text = "Active"
        
        guard let userInfo = userInfo else {
            return
        }
        
        guard let loginTime: TimeInterval = userInfo.value(forKey: "login")?.doubleValue else {
            return
        }
        
        let now = Date().timeIntervalSince1970
        let ago = WSTimeInterval(timeInterval: now - loginTime)
        label.text = "Active " + ago.asString() + " ago"
        
    }
    
    func configureAsLanguageSpoken(_ userInfo: AnyObject?) {
        
        label.text = "Languages spoken: "
        
        guard let userInfo = userInfo else {
            return
        }
        
        guard let languages = userInfo.value(forKey: "languagesspoken") as? String else {
            return
        }
        
        label.text = "Languages spoken: " + languages
    }
    
}
