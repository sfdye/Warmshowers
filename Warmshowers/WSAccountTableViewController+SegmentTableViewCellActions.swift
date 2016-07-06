//
//  WSAccountTableViewController+SegmentTableViewCellActions.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 29/12/15.
//  Copyright © 2015 Rajan Fernandez. All rights reserved.
//

import UIKit

extension WSAccountTableViewController : SegmentTableViewCellActions {
    
    func didSelectAbout() {
        switchToTab(.about)
    }
    
    func didSelectHosting() {
        switchToTab(.hosting)
    }
    
    func didSelectContact() {
        switchToTab(.contact)
    }
    
    func switchToTab(_ tab: HostProfileTab) {
        self.tab = tab
        self.tableView.reloadSections(IndexSet(integer: 3), with: UITableViewRowAnimation.none)
    }
    
}
