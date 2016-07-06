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
    var date: Date = Date()
    var type: WSRecommendationType = .ForHost
    var rating: WSRecommendationRating = .Positive
    var author: WSUser?
    var recommendedUserUID: Int?
    var recommendedUserName: String?
    var authorImageURL: String?
    var authorImage: UIImage?
    
    var month: Int {
        let calendar = Calendar(calendarIdentifier: Calendar.Identifier.gregorian)!
        return calendar.components([.month], from: date).month!
    }
    
    var year: Int {
        let calendar = Calendar(calendarIdentifier: Calendar.Identifier.gregorian)!
        return calendar.components([.year], from: date).year!
    }
    
    var hasBody: Bool {
        return body != nil && body != ""
    }
    
    
    // MARK: Initialisers
    
    init() {}
    
    init?(json: AnyObject) {
        
        guard let body = json.value(forKey: "body") as? String,
              let date = json.value(forKey: "field_hosting_date")?.intValue,
              let type = json.value(forKey: "field_guest_or_host") as? String,
              let rating = json.value(forKey: "field_rating") as? String,
              let fullname = json.value(forKey: "fullname") as? String,
              let name = json.value(forKey: "name") as? String,
              let uid = json.value(forKey: "uid")?.intValue,
              let uid_1 = json.value(forKey: "uid_1")?.intValue
        else {
            print("Failed to initialise WSRecommendation due to invalid input")
            return nil
        }
        
        self.body = body
        self.date = Date(timeIntervalSince1970: Double(date))
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
