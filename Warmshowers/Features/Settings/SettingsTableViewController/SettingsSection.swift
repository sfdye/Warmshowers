//
//  SettingsSection.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 21/09/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

struct SettingsSection {
    
    var title: String
    var cells: [SettingsCell]
    
    init(withTitle title: String, andCells cells: [SettingsCell]) {
        self.title = title
        self.cells = cells
    }
}
