//
//  WSSettingsTableViewController.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 19/11/15.
//  Copyright © 2015 Rajan Fernandez. All rights reserved.
//

import UIKit

let SBID_Settings = "Settings"
let SID_SettingsToRoutes = "SettingsToRoutes"

class WSSettingsTableViewController: UITableViewController {
    
    // Delegates
    var navigation: WSNavigationProtocol = WSNavigationDelegate.sharedNavigationDelegate
    var api: WSAPICommunicatorProtocol = WSAPICommunicator.sharedAPICommunicator
    var session: WSSessionStateProtocol = WSSessionState.sharedSessionState
    var store: WSStoreProtocol = WSStore.sharedStore
    var alert: WSAlertProtocol = WSAlertDelegate.sharedAlertDelegate
    
    lazy var settings: [SettingsSection] = {
        var sections = [SettingsSection]()
        let warmshowersSection = SettingsSection(withTitle: "Warmshowers.org", andCells:
            [
                SettingsCell(withTitle: "Visit the website",
                             cellID: DisclosureCellID,
                             andTag: 10),
                SettingsCell(withTitle: "FAQ",
                             cellID: DisclosureCellID,
                             andTag: 11)
            ]
        )
        sections.append(warmshowersSection)
        let helpSection = SettingsSection(withTitle: "Help", andCells:
            [
                SettingsCell(withTitle: "Contact",
                          cellID: DisclosureCellID,
                          andTag: 20)
            ]
        )
        sections.append(helpSection)
        let mapSection = SettingsSection(withTitle: "Map", andCells:
            [
                SettingsCell(withTitle: "Routes",
                             cellID: DisclosureCellID,
                             andTag: 30)
            ]
        )
        sections.append(mapSection)
        let logoutSection = SettingsSection(withTitle: "", andCells:
            [
                SettingsCell(withTitle: "Logout",
                             cellID: LogoutCellID,
                             andTag: 40)
            ]
        )
        sections.append(logoutSection)
        let deleteCacheSection = SettingsSection(withTitle: "", andCells:
            [
                SettingsCell(withTitle: "Delete cached data",
                             cellID: LogoutCellID,
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
