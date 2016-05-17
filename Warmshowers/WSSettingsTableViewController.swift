//
//  WSSettingsTableViewController.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 19/11/15.
//  Copyright © 2015 Rajan Fernandez. All rights reserved.
//

import UIKit

class WSSettingsTableViewController: UITableViewController {
    
    // Delegates
    var navigationDelegate: WSNavigationProtocol? = WSNavigationDelegate.sharedNavigationDelegate
    var apiCommunicator: WSAPICommunicatorProtocol? = WSAPICommunicator.sharedAPICommunicator
    var session: WSSessionStateProtocol? = WSSessionState.sharedSessionState
    var store: WSStoreProtocol? = WSStore.sharedStore
    var alertDelegate: WSAlertProtocol? = WSAlertDelegate.sharedAlertDelegate
    
    let settings = [
        [
            "section_title" : "Warmshowers.org",
            "cells" : [
                [
                    "title" : "Visit the website",
                    "cell_id": DisclosureCellID,
                    "tag" : 10
                ],
                [
                    "title": "FAQ",
                    "cell_id": DisclosureCellID,
                    "tag" : 11
                ]
            ]
        ],
        [
            "section_title" : "Help",
            "cells" : [
                [
                    "title" : "Contact",
                    "cell_id": DisclosureCellID,
                    "tag" : 20
                ]
            ]
        ],
        [
            "cells" : [
                [
                    "title" : "Logout",
                    "cell_id": LogoutCellID,
                    "tag" : 30
                ]
            ]
        ]
    ]
    
    override func viewWillAppear(animated: Bool) {
        alertDelegate?.hideAllBanners()
    }
}
