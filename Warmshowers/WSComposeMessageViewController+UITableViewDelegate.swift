//
//  WSComposeMessageViewController+UITableViewDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 26/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

extension WSComposeMessageViewController : UITableViewDelegate {
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 && indexPath.row == 2 {
            return tableView.bounds.height - 2 * detailCellHeight - (navigationController?.navigationBar.bounds.height)!
        } else {
            return detailCellHeight
        }
    }
    
}