//
//  ComposeMessageViewControllerDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 3/01/17.
//  Copyright © 2017 Rajan Fernandez. All rights reserved.
//

import Foundation

protocol ComposeMessageViewControllerDelegate: class {
    
    func composeMessageViewControllerDidSendANewMessage(_ controller: ComposeMessageViewController)
    
    func composeMessageViewController(_ controller: ComposeMessageViewController, didReplyOnThreadWithThreadID threadID: Int)
    
}
