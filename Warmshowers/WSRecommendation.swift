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
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        return (calendar as NSCalendar).components([.month], from: date).month!
    }
    
    var year: Int {
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        return (calendar as NSCalendar).components([.year], from: date).year!
    }
    
    var hasBody: Bool {
        return body != nil && body != ""
    }
    
    
    // MARK: Initialisers
    
    init() {}
    
    init?(json: Any) {
        
        guard let json = json as? [String: Any] else {
            return nil
        }
        
        guard let body = json["body"] as? String,
              let date = json["field_hosting_date"] as? Int,
              let type = json["field_guest_or_host"] as? String,
              let rating = json["field_rating"] as? String,
              let fullname = json["fullname"] as? String,
              let name = json["name"] as? String,
              let uid = json["uid"] as? Int,
              let uid_1 = json["uid_1"] as? Int
        else {
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
