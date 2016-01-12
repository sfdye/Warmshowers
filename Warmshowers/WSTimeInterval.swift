//
//  WSTime.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 3/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

enum TimeUnit {
    case seconds
    case minutes
    case hours
    case days
    case weeks
    case months
    case years
    
    func stringValue(plural: Bool) -> String {
        switch self {
        case seconds:
            return plural ? "seconds" : "second"
        case minutes:
            return plural ? "minutes" : "minute"
        case .hours:
            return plural ? "hours" : "hour"
        case .days:
            return plural ? "days" : "day"
        case .weeks:
            return plural ? "weeks" : "week"
        case .months:
            return plural ? "months" : "month"
        case .years:
            return plural ? "years" : "year"
        }
    }
    
    func inSeconds() -> Int {
        switch self {
        case .seconds:
            return 1
        case .minutes:
            return 60
        case .hours:
            return 3600
        case .days:
            return 86400
        case .weeks:
            return 604800
        case .months:
            return 2592000
        case .years:
            return 31536000
        }
    }
}

struct WSTimeInterval {
    
    let maxUnitsInString = 2
    
    var time: Int
    
    init(timeInterval: NSTimeInterval) {
        time = Int(timeInterval)
    }
    
    init(timeInterval: Int) {
        time = timeInterval
    }
    
    // Formats an integer time (in seconds) to a String with the two largest time units
    // i.e. 4 months 6 days
    //      2 hours 3 minutes
    func asString() -> String {
        
        var time = self.time
        var count = 0
        var string = ""
        let units: [TimeUnit] = [.years, .months, .weeks, .days, .hours, .minutes, .seconds]
        
        func done() -> Bool {
            return (count >= maxUnitsInString) ? true : false
        }
        
        func integerTime(unit: TimeUnit) -> Int {
            return time / unit.inSeconds()
        }
        
        func addToString(value: Int, unit: TimeUnit) {
            if !done() {
                let plural = (value != 1) ? true : false
                if count > 0 {
                    string += " "
                }
                string += String(format: "%i %@", arguments: [value, unit.stringValue(plural)])
                count++
                return
            } else {
                return
            }
        }
        
        func addToTime(value: Int, unit: TimeUnit) {
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