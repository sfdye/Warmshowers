//
//  ComposeMessageViewController+UITableViewDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 26/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

extension ComposeMessageViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath as NSIndexPath).section == 0 && (indexPath as NSIndexPath).row == 2 {
            return tableView.bounds.height - 2 * detailCellHeight - (navigationController?.navigationBar.bounds.height)!
        } else {
            return detailCellHeight
        }
    }
    
}
