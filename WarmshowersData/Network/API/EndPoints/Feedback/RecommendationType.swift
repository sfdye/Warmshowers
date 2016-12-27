//
//  RecommendationFor.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 7/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

public enum RecommendationType: String {
    case forGuest = "Guest"
    case forHost = "Host"
    case metTraveling = "Met Traveling"
    case other = "Other"
    
    public static var allValues: [RecommendationType] {
        return [
            .forGuest,
            .forHost,
            .metTraveling,
            .other
        ]
    }
    
}
