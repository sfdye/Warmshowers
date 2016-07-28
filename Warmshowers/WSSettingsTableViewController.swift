//
//  WSSettingsTableViewController.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 19/11/15.
//  Copyright © 2015 Rajan Fernandez. All rights reserved.
//

import UIKit

let SBID_Settings = "Settings"

class WSSettingsTableViewController: UITableViewController {
    
    // Delegates
    var navigation: WSNavigationProtocol = WSNavigationDelegate.sharedNavigationDelegate
    var api: WSAPICommunicatorProtocol = WSAPICommunicator.sharedAPICommunicator
    var session: WSSessionStateProtocol = WSSessionState.sharedSessionState
    var store: WSStoreProtocol = WSStore.sharedStore
    var alert: WSAlertProtocol = WSAlertDelegate.sharedAlertDelegate
    
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
        alert.hideAllBanners()
    }
    
    func logout() {
        do {
            session.deleteSessionData()
            try store.clearout()
            navigation.showLoginScreen()
        } catch {
            // Suggest that the user delete the app for privacy.
            alert.presentAlertFor(self, withTitle: "Data Error", button: "OK", message: "Sorry, an error occured while removing your account data from this iPhone. If you would like to remove your Warmshowers messages from this iPhone please try deleting the Warmshowers app.", andHandler: { [weak self] (action) in
                self?.navigation.showLoginScreen()
                })
        }
    }
    
}
