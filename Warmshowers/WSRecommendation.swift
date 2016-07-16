//
//  WSFeedback.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 3/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

class WSRecommendation {
    
    // MARK: Properties
    
    var body: String?
    var date: NSDate = NSDate()
    var type: WSRecommendationType = .ForHost
    var rating: WSRecommendationRating = .Positive
    var author: WSUser?
    var recommendedUserUID: Int?
    var recommendedUserName: String?
    var authorImageURL: String?
    var authorImage: UIImage?
    
    var month: Int {
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        return calendar.components([.Month], fromDate: date).month
    }
    
    var year: Int {
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        return calendar.components([.Year], fromDate: date).year
    }
    
    var hasBody: Bool {
        return body != nil && body != ""
    }
    
    
    // MARK: Initialisers
    
    init() {}
    
    init?(json: AnyObject) {
        
        guard let body = json.valueForKey("body") as? String,
              let date = json.valueForKey("field_hosting_date")?.integerValue,
              let type = json.valueForKey("field_guest_or_host") as? String,
              let rating = json.valueForKey("field_rating") as? String,
              let fullname = json.valueForKey("fullname") as? String,
              let name = json.valueForKey("name") as? String,
              let uid = json.valueForKey("uid")?.integerValue,
              let uid_1 = json.valueForKey("uid_1")?.integerValue
        else {
            return nil
        }
        
        self.body = body
        self.date = NSDate(timeIntervalSince1970: Double(date))
        switch type {
        case "Guest":
            self.type = .ForGuest
        case "Host":
            self.type = .ForHost
        case "Met Traveling":
            self.type = .MetTraveling
        case "Other":
            self.type = .Other
        default:
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
            return nil
        }
        self.author = WSUser(fullname: fullname, name: name, uid: uid)
        self.recommendedUserUID = uid_1
    }
    
}