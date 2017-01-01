//
//  MessageThreadTableViewController+Navigation.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 13/07/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

let SID_ReplyToMessageThread = "ToReplyToMessage"
let SID_MessageThreadToUserProfile = "MessageThreadToUserProfile"

extension MessageThreadTableViewController {
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        switch identifier {
        case SID_ReplyToMessageThread:
            return threadID != nil
        case SID_MessageThreadToUserProfile:
            print((sender as! UIView).tag)
            return true
        default:
            return false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        switch identifier {
        case SID_ReplyToMessageThread:
            let navVC = segue.destination as! UINavigationController
            let composeMessageVC = navVC.viewControllers.first as! ComposeMessageViewController
            composeMessageVC.configureAsReply(threadID)
        case SID_MessageThreadToUserProfile:
            print((sender as! UIView).tag)
            let row = (sender as! UIView).tag
            guard row >= 0, row < tableView.dataSource!.tableView(tableView, numberOfRowsInSection: 0) else {
                return
            }
            let indexPath = IndexPath(row: row, section: 0)
            let message = fetchedResultsController.object(at: indexPath)
            let authorUID = message.author?.uid
            print(authorUID)
//            guard sender is User else { return }
//            let accountTVC = segue.destination as! UserProfileTableViewController
//            accountTVC.user = sender as? User
            break
        default:
            break
        }
    }
    
}
