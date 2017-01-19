//
//  MessageThreadsViewController+ComposeMessageViewControllerDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 3/01/17.
//  Copyright © 2017 Rajan Fernandez. All rights reserved.
//

import Foundation

extension MessageThreadsViewController: ComposeMessageViewControllerDelegate {
    
    func composeMessageViewControllerDidSendANewMessage(_ controller: ComposeMessageViewController) {
        needsUpdate = true
    }
    
    func composeMessageViewController(_ controller: ComposeMessageViewController, didReplyOnThreadWithThreadID threadID: Int) {
        needsUpdate = true
    }
    
}
