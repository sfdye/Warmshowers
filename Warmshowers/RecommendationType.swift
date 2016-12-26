//
//  RecommendationFor.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 7/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

enum RecommendationType : String {
    case ForGuest = "Guest"
    case ForHost = "Host"
    case MetTraveling = "Met Traveling"
    case Other = "Other"
    
    static let allValues = [ForGuest, ForHost, MetTraveling, Other]
    
    mutating func setFromRawValue(_ rawValue: String) {
        let allValues = WSRecommendationType.allValues
        for value in allValues {
            if value.rawValue == rawValue {
                self = value
            }
        }
    }
    
}
