//
//  MessageThreadsViewController+MessageThreadViewControllerDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 19/01/17.
//  Copyright © 2017 Rajan Fernandez. All rights reserved.
//

import Foundation

extension MessageThreadsViewController: MessageThreadViewControllerDelegate {
    
    func replyToMessageForMessageThreadViewController(_ viewController: MessageThreadViewController) {
        performSegue(withIdentifier: SID_ThreadsToReply, sender: viewController)
    }
    
}
