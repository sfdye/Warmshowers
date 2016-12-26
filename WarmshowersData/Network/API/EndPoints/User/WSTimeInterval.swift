//
//  WSTimeInterval.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 3/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

struct WSTimeInterval {
    
    let maxUnitsInString = 2
    
    var time: Int
    
    init(timeInterval: TimeInterval) {
        time = Int(timeInterval)
    }
    
    init(timeInterval: Int) {
        time = timeInterval
    }
    
    // Formats an integer time (in seconds) to a String with the two largest time units
    // i.e. 4 months 6 days
    //      2 hours 3 minutes
    var asString: String {
        
        var time = self.time
        var count = 0
        var string = ""
        let units: [TimeUnit] = [.years, .months, .weeks, .days, .hours, .minutes, .seconds]
        
        func done() -> Bool {
            return (count >= maxUnitsInString) ? true : false
        }
        
        func integerTime(_ unit: TimeUnit) -> Int {
            return time / unit.inSeconds()
        }
        
        func addToString(_ value: Int, unit: TimeUnit) {
            if !done() {
                let plural = (value != 1) ? true : false
                if count > 0 {
                    string += " "
                }
                string += String(format: "%i %@", arguments: [value, unit.stringValue(plural)])
                count += 1
                return
            } else {
                return
            }
        }
        
        func addToTime(_ value: Int, unit: TimeUnit) {
            time += value * unit.inSeconds()
        }
        
        // Loop though the time units and add the two largest non-zero quantities of time to the string
        for unit in units {
            if !done() {
                let t = integerTime(unit)
                if t > 0 {
                    addToString(t, unit: unit)
                    addToTime(-t, unit: unit)
                }
                
            } else {
                continue
            }
        }
        return string
    }
    
}
