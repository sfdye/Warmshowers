//
//  RecommendationRating.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 7/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

public enum RecommendationRating: String {
    case positive = "Positive"
    case neutral = "Neutral"
    case negative = "Negative"
    
    public static var allValues: [RecommendationRating] {
        return [
            .positive,
            .neutral,
            .negative
        ]
    }
}
