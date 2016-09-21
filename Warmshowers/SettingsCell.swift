//
//  SettingsCell.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 21/09/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

struct SettingsCell {
    
    var title: String
    var detail: String?
    var cellID: String
    var tag: Int
    
    init(withTitle title: String, cellID: String, andTag tag: Int, andDetail detail: String? = nil) {
        self.title = title
        self.detail = detail
        self.cellID = cellID
        self.tag = tag
    }
    
}
