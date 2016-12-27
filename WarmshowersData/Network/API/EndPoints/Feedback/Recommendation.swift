//
//  Recommendation.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 3/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

public class Recommendation {
    
    // MARK: Properties
    
    public var body: String?
    public var date: Date = Date()
    public var type: RecommendationType = .forHost
    public var rating: RecommendationRating = .positive
    public var author: User?
    public var recommendedUserUID: Int?
    public var recommendedUserName: String?
    public var authorImageURL: String?
    public var authorImage: UIImage?
    
    public var month: Int {
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        return (calendar as NSCalendar).components([.month], from: date).month!
    }
    
    public var year: Int {
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        return (calendar as NSCalendar).components([.year], from: date).year!
    }
    
    public var hasBody: Bool {
        return body != nil && body != ""
    }
    
    
    // MARK: Initialisers
    
    public init() {}
    
    init?(json: Any) {
        
        let json = json as AnyObject

        guard
            let body = json.value(forKey: "body") as? String,
            let date = json.value(forKey: "field_hosting_date") as? Int,
            let type = json.value(forKey: "field_guest_or_host") as? String,
            let rating = json.value(forKey: "field_rating") as? String,
            let fullname = json.value(forKey: "fullname") as? String,
            let name = json.value(forKey: "name") as? String,
            let uid = Int(json.value(forKey: "uid") as? String ?? ""),
            let uid_1 = Int(json.value(forKey: "uid_1") as? String ?? "")
        else {
            return nil
        }
        
        self.body = body
        self.date = Date(timeIntervalSince1970: Double(date))
        switch type {
        case "Guest":
            self.type = .forGuest
        case "Host":
            self.type = .forHost
        case "Met Traveling":
            self.type = .metTraveling
        case "Other":
            self.type = .other
        default:
            return nil
        }
        switch rating {
        case "Positive":
            self.rating = .positive
        case "Negative":
            self.rating = .negative
        case "Neutral":
            self.rating = .neutral
        default:
            return nil
        }
        self.author = User(fullname: fullname, name: name, uid: uid)
        self.recommendedUserUID = uid_1
    }
    
}
