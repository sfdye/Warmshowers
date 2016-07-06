//
//  WSDistance.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 18/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

struct WSDistance {
    
    // Metric values
    var metres: Double!
    var kilometres: Double { return metres/1000 }
    
    // US values
    var feet: Double { return metres*3.28084 }
    var miles: Double { return metres/1609.34 }
    
    init(metres: Double) {
        self.metres = metres
    }
    
    // Returns a string of the metric distance with its units
    func stringWithUnits(_ metric: Bool) -> String {
        if metric {
            if metres < 1000 {
                return String(format: "%.0f m", arguments: [metres])
            } else {
                return String(format: "%.0f km", arguments: [kilometres])
            }
        } else {
            if feet < 528 {
                return String(format: "%.0f ft", arguments: [feet])
            } else {
                var format: String
                if miles < 1 {
                    format = "%.1f"
                } else {
                    format = "%.0f"
                }
                return String(format: format + " miles", arguments: [miles])
            }
        }
    }
    
}
