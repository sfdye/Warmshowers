//
//  MessageThreadsViewController+MessageThreadsErrorViewDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 20/01/17.
//  Copyright © 2017 Rajan Fernandez. All rights reserved.
//

import Foundation

extension MessageThreadsViewController: MessageThreadsErrorViewDelegate {
    
    func messageThreadsErrorViewDidSelectUpdate(_ view: MessageThreadsErrorView) {
        update()
    }
    
}
