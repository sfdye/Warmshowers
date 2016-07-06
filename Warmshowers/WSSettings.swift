//
//  WSSettings.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 18/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

struct WSSettings {
    
    // Returns true if the app units setting is set to metric (false for US units)
    //
    static func metric() -> Bool {
        
        let defaults = UserDefaults.standard()
        
        if let units = defaults.value(forKey: "units") as? String {
            if units != "metric" {
                return false
            }
        }
        return true
    }
}
