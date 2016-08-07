//
//  ShortcutIdentifier.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 8/08/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

enum ShortcutIdentifier: String {
    case LocationSearch
    case KeywordSearch
    case Messages
    
    // MARK: Initializers
    
    init?(fullType: String) {
        guard let last = fullType.componentsSeparatedByString(".").last else { return nil }
        self.init(rawValue: last)
    }
    
    // MARK: Properties
    
    var type: String {
        return NSBundle.mainBundle().bundleIdentifier! + ".\(self.rawValue)"
    }
    
}