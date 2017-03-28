//
//  SettingsTableViewController.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 19/11/15.
//  Copyright © 2015 Rajan Fernandez. All rights reserved.
//

import UIKit
import WarmshowersData

let SBID_Settings = "Settings"
let SID_SettingsToRoutes = "SettingsToRoutes"

class SettingsTableViewController: UITableViewController, Delegator, DataSource {
    
    lazy var settings: [SettingsSection] = {
        var sections = [SettingsSection]()
        let warmshowersSection = SettingsSection(withTitle: "Warmshowers.org",
                                                 andCells:
            [
                SettingsCell(withTitle: NSLocalizedString("Visit the website", comment: "Settings option title"),
                             cellID: "Disclosure",
                             andTag: 10),
                SettingsCell(withTitle: NSLocalizedString("FAQ", comment: "Settings option title"),
                             cellID: "Disclosure",
                             andTag: 11)
            ]
        )
        sections.append(warmshowersSection)
        let helpSection = SettingsSection(withTitle: NSLocalizedString("Help", comment: "Settings option title"),
                                          andCells:
            [
                SettingsCell(withTitle: NSLocalizedString("Contact", comment: "Settings option title"),
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
                SettingsCell(withTitle: NSLocalizedString("Logout", comment: "Settings option title"),
                             cellID: "Logout",
                             andTag: 40)
            ]
        )
        sections.append(logoutSection)
        let deleteCacheSection = SettingsSection(withTitle: "", andCells:
            [
                SettingsCell(withTitle: NSLocalizedString("Delete cached data", comment: "Settings option title"),
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
