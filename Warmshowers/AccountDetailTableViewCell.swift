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
    func configureAsMemberFor(userInfo: AnyObject?) {
        
        label.text = "Member for"
        
        guard let userInfo = userInfo else {
            return
        }
        
        guard let created: NSTimeInterval = userInfo.valueForKey("created")?.doubleValue else {
            return
        }
        
        let now = NSDate().timeIntervalSince1970
        let since = WSTimeInterval(timeInterval: now - created)
        label.text = "Member for " + since.asString()
    }
    
    // Configures the cell to show how long ago the user was last logged in
    //
    func configureAsActiveAgo(userInfo: AnyObject?) {
        
        label.text = "Active"
        
        guard let userInfo = userInfo else {
            return
        }
        
        guard let loginTime: NSTimeInterval = userInfo.valueForKey("login")?.doubleValue else {
            return
        }
        
        let now = NSDate().timeIntervalSince1970
        let ago = WSTimeInterval(timeInterval: now - loginTime)
        label.text = "Active " + ago.asString() + " ago"
        
    }
    
    func configureAsLanguageSpoken(userInfo: AnyObject?) {
        
        label.text = "Languages spoken: "
        
        guard let userInfo = userInfo else {
            return
        }
        
        guard let languages = userInfo.valueForKey("languagesspoken") as? String else {
            return
        }
        
        label.text = "Languages spoken: " + languages
    }
    
}
