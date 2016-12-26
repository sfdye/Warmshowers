//
//  SettingsTableViewController.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 19/11/15.
//  Copyright © 2015 Rajan Fernandez. All rights reserved.
//

import UIKit

let SBID_Settings = "Settings"
let SID_SettingsToRoutes = "SettingsToRoutes"

class SettingsTableViewController: UITableViewController {
    
    // Delegates
    var navigation: NavigationProtocol = NavigationDelegate.sharedNavigationDelegate
    var api: APICommunicatorProtocol = APICommunicator.sharedAPICommunicator
    var session: SessionStateProtocol = SessionState.sharedSessionState
    var store: StoreProtocol = Store.sharedStore
    var alert: AlertProtocol = AlertDelegate.sharedAlertDelegate
    
    lazy var settings: [SettingsSection] = {
        var sections = [SettingsSection]()
        let warmshowersSection = SettingsSection(withTitle: "Warmshowers.org", andCells:
            [
                SettingsCell(withTitle: "Visit the website",
                             cellID: "Disclosure",
                             andTag: 10),
                SettingsCell(withTitle: "FAQ",
                             cellID: "Disclosure",
                             andTag: 11)
            ]
        )
        sections.append(warmshowersSection)
        let helpSection = SettingsSection(withTitle: "Help", andCells:
            [
                SettingsCell(withTitle: "Contact",
                          cellID: "Disclosure",
                          andTag: 20)
            ]
        )
        sections.append(helpSection)
//        let mapSection = SettingsSection(withTitle: "Map", andCells:
//            [
//                SettingsCell(withTitle: "Routes",
//                             cellID: "Disclosure",
//                             andTag: 30)
//            ]
//        )
//        sections.append(mapSection)
        let logoutSection = SettingsSection(withTitle: "", andCells:
            [
                SettingsCell(withTitle: "Logout",
                             cellID: "Logout",
                             andTag: 40)
            ]
        )
        sections.append(logoutSection)
        let deleteCacheSection = SettingsSection(withTitle: "", andCells:
            [
                SettingsCell(withTitle: "Delete cached data",
                             cellID: "Logout",
                             andTag: 50)
            ]
        )
        sections.append(deleteCacheSection)
        
        return sections
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        alert.hideAllBanners()
    }
    
}
