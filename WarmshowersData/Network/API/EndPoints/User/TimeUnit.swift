//
//  TimeUnit.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 27/12/16.
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
    
    func stringValue(_ plural: Bool) -> String {
        switch self {
        case .seconds:
            return plural ? "seconds" : "second"
        case .minutes:
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
