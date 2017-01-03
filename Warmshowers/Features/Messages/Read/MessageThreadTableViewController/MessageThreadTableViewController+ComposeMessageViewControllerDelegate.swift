//
//  MessageThreadTableViewController+ComposeMessageViewControllerDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 3/01/17.
//  Copyright © 2017 Rajan Fernandez. All rights reserved.
//

import Foundation

extension MessageThreadTableViewController: ComposeMessageViewControllerDelegate {
    
    func composeMessageViewControllerDidSendANewMessage(_ controller: ComposeMessageViewController) { }
    
    func composeMessageViewController(_ controller: ComposeMessageViewController, didReplyOnThreadWithThreadID threadID: Int) {
        guard let currentThreadID = self.threadID, currentThreadID == threadID else { return }
        needsUpdate = true
    }
    
}
