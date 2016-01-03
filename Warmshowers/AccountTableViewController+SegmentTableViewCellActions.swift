//
//  AccountTableViewController+SegmentTableViewCellActions.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 29/12/15.
//  Copyright © 2015 Rajan Fernandez. All rights reserved.
//

import Foundation

extension AccountTableViewController : SegmentTableViewCellActions {
    
    func didSelectAbout() {
        switchToTab(.About)
    }
    
    func didSelectHosting() {
        switchToTab(.Hosting)
    }
    
    func didSelectContact() {
        switchToTab(.Contact)
    }
    
    func switchToTab(tab: HostProfileTab) {
        self.tab = tab
        self.tableView.reloadSections(NSIndexSet(index: 3), withRowAnimation: UITableViewRowAnimation.None)
    }
    
}