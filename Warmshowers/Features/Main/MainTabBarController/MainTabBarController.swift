//
//  MainTabBarController.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 19/11/15.
//  Copyright © 2015 Rajan Fernandez. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    var messageThreadsTableViewController: MessageThreadsViewController? {
        let messageThreadsTableViewController = (self.viewControllers?[1] as? UINavigationController)?.viewControllers.first as? MessageThreadsViewController
        assert(messageThreadsTableViewController != nil, "Main tab bar will return nil instead of the MessageThreadsViewController. Check this getter.")
        return messageThreadsTableViewController
    }

}
