//
//  MessageThreadViewControllerDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 19/01/17.
//  Copyright © 2017 Rajan Fernandez. All rights reserved.
//

import Foundation

protocol MessageThreadViewControllerDelegate: class {
    
    func replyToMessageForMessageThreadViewController(_ viewController: MessageThreadViewController)
    
}
