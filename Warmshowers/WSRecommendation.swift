//
//  WSFeedback.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 3/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

struct WSRecommendation {
    
    var body: String = ""
    var date: NSDate = NSDate()
    var recommendationFor: WSRecommendationFor = .Host
    var rating: WSRecommendationRating = .Positive
    var author: WSUser?
    var recommendedUserUID: Int?
    var authorImage: UIImage?
    var month: Int {
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        return calendar.components([.Month], fromDate: date).month
    }
    var year: Int {
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        return calendar.components([.Year], fromDate: date).year
    }
    
    init() { }
    
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
        case "Met Traveling":
            self.recommendationFor = .MetTraveling
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