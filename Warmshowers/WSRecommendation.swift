//
//  WSFeedback.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 3/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

enum WSRecommendationRating {
    case Positive
    case Negative
    case Neutral
    
    func asString() -> String {
        switch self {
        case .Positive:
            return "Positive"
        case .Negative:
            return "Negative"
        case .Neutral:
            return "Neutral"
        }
    }
}

enum WSRecommendationFor {
    case Guest
    case Host
    case MetTravelling
    case Other
    
    func asString() -> String {
        switch self {
        case .Guest:
            return "Guest"
        case .Host:
            return "Host"
        case .MetTravelling:
            return "Met Travelling"
        case .Other:
            return "Other"
        }
    }
}

struct WSRecommendation {
    
    var body: String
    var date: NSDate
    var recommendationFor: WSRecommendationFor
    var rating: WSRecommendationRating
    var author: WSUser
    var recommendedUserUID: Int
    var authorImage: UIImage?
    
    init?(json: AnyObject) {
        
        guard let body = json.valueForKey("body") as? String,
              let date = json.valueForKey("field_hosting_date")?.integerValue,
              let recommendationFor = json.valueForKey("field_guest_or_host") as? String,
              let rating = json.valueForKey("field_rating") as? String,
              let fullname = json.valueForKey("fullname") as? String,
              let name = json.valueForKey("name") as? String,
              let uid = json.valueForKey("uid")?.integerValue,
              let uid_1 = json.valueForKey("uid_1")?.integerValue
        else {
            print("Failed to initialise WSRecommendation due to invalid input")
            return nil
        }
        
        self.body = body
        self.date = NSDate(timeIntervalSince1970: Double(date))
        switch recommendationFor {
        case "Guest":
            self.recommendationFor = .Guest
        case "Host":
            self.recommendationFor = .Host
        case "Met_Travelling":
            self.recommendationFor = .MetTravelling
        case "Other":
            self.recommendationFor = .Other
        default:
            print("Failed to initialise WSRecommendation due to an unrecognised guest_or_host value")
            return nil
        }
        switch rating {
        case "Positive":
            self.rating = .Positive
        case "Negative":
            self.rating = .Negative
        case "Neutral":
            self.rating = .Neutral
        default:
            print("Failed to initialise WSRecommendation due to an unrecognised rating")
            return nil
        }
        self.author = WSUser(fullname: fullname, name: name, uid: uid)
        self.recommendedUserUID = uid_1
    }
    
}