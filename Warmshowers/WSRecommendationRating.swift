//
//  WSRecommendationRating.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 7/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

enum WSRecommendationRating : String {
    case Positive = "Positive"
    case Neutral = "Neutral"
    case Negative = "Negative"
    
    static let allValues = [Positive, Neutral, Negative]
    
    mutating func setFromRawValue(rawValue: String) {
        let allValues = WSRecommendationRating.allValues
        for value in allValues {
            if value.rawValue == rawValue {
                self = value
            }
        }
    }
}
