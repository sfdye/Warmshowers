//
//  WSComposeMessageViewController+UITableViewDataSource.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 26/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

let RUID_ComposeMessageDetail = "ComposeMessageDetail"
let RUID_ComposeMessageBody = "ComposeMessageBody"

extension WSComposeMessageViewController : UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier(RUID_ComposeMessageDetail, forIndexPath: indexPath) as! ComposeMessageDetailTableViewCell
            cell.detailLabel!.text = "To:"
            cell.detailTextField!.text = recipientStringForRecipients(recipients)
            cell.userInteractionEnabled = false
            return cell
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier(RUID_ComposeMessageDetail, forIndexPath: indexPath) as! ComposeMessageDetailTableViewCell
            cell.detailLabel!.text = "Subject:"
            cell.detailTextField!.text = subject
            cell.detailTextField!.delegate = self
            return cell
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier(RUID_ComposeMessageBody, forIndexPath: indexPath) as! ComposeMessageBodyTableViewCell
            cell.textView.delegate = self
            return cell
        }
    }
    
}