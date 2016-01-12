//
//  WSRecommendationFor.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 7/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

enum WSRecommendationFor : String {
    case Guest = "Guest"
    case Host = "Host"
    case MetTraveling = "Met Traveling"
    case Other = "Other"
    
    static let allValues = [Guest, Host, MetTraveling, Other]
    
    mutating func setFromRawValue(rawValue: String) {
        let allValues = WSRecommendationFor.allValues
        for value in allValues {
            if value.rawValue == rawValue {
                self = value
            }
        }
    }
    
}