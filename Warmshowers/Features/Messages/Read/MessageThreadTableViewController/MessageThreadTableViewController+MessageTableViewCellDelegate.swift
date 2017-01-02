//
//  MessageThreadTableViewController+MessageTableViewCellDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 2/01/17.
//  Copyright © 2017 Rajan Fernandez. All rights reserved.
//

import Foundation

extension MessageThreadTableViewController: MessageTableViewCellDelegate {
    
    func messageAuthorTapped(withUID uid: Int) {
        performSegue(withIdentifier: SID_MessageThreadToUserProfile, sender: uid)
    }
    
}
