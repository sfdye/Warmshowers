//
//  WSComposeMessageViewController+UITableViewDataSource.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 26/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

extension WSComposeMessageViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (indexPath as NSIndexPath).row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: ComposeMessageDetailCellID, for: indexPath) as! ComposeMessageDetailTableViewCell
            cell.detailLabel!.text = "To:"
            cell.detailTextField!.text = getRecipientString()
            cell.isUserInteractionEnabled = false
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: ComposeMessageDetailCellID, for: indexPath) as! ComposeMessageDetailTableViewCell
            cell.detailLabel!.text = "Subject:"
            cell.detailTextField!.text = subject
            cell.detailTextField!.delegate = self
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: ComposeMessageBodyCellID, for: indexPath) as! ComposeMessageBodyTableViewCell
            cell.textView.delegate = self
            return cell
        }
    }
    
}
