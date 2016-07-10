//
//  File.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 20/11/15.
//  Copyright © 2015 Rajan Fernandez. All rights reserved.
//

import UIKit

class WSUser: Hashable {
    
    var fullname: String
    var name: String
    var uid: Int
    var isAvailable: Bool = false
    var joined: NSDate?
    var lastLoggedIn: NSDate?
    var languagesSpoken: String?
    var comments: String?
    var hostingInfo = WSHostingInfo()
    var offers = WSOffers()
    var phoneNumbers = WSPhoneNumbers()
    var feedback = [WSRecommendation]()
    var profileImage: UIImage?
    var profileImageURL: String?
    
    var membershipDuration: WSTimeInterval? {
        guard let joined = joined else { return nil }
        return WSTimeInterval(timeInterval: NSDate().timeIntervalSince1970 - joined.timeIntervalSince1970)
    }
    
    var lastLoggedInAgo: WSTimeInterval? {
        guard let lastLoggedIn = lastLoggedIn else { return nil }
        return WSTimeInterval(timeInterval: NSDate().timeIntervalSince1970 - lastLoggedIn.timeIntervalSince1970)
    }
    
    // MARK: Hashable
    
    var hashValue: Int { return uid }
    
    // MARK: Initialisers
    
    init(fullname: String, name: String, uid: Int) {
        self.fullname = fullname
        self.name = name
        self.uid = uid
    }
    
    convenience init?(json: AnyObject) {
        
        guard
            let fullname = json["fullname"] as? String,
            let name = json["name"] as? String,
            let uidString = json["uid"] as? String,
            let uid = Int(uidString)
            else {
                return nil
        }
        
        self.init(fullname: fullname, name: name, uid: uid)
        
        isAvailable = json["notcurrentlyavailable"] != "true"

        if let created: NSTimeInterval = json["created"], let createdDouble = Double(created) {
            joined = NSDate(timeIntervalSince1970: createdDouble)
        }
        
        if let login: NSTimeInterval = json["login"], let loginDouble = Double(created) {
            lastLoggedIn = NSDate(timeIntervalSince1970: loginDouble)
        }

        comments = json["comments"]
        languagesSpoken = json["languagesspoken"]

        hostingInfo.update(json)
        offers.update(json)
        phoneNumbers.update(json)
        
        profileImageURL = json["profile_image_mobile_profile_photo_std"]
    }
}

func ==(lhs: WSUser, rhs: WSUser) -> Bool {
    return lhs.hashValue == rhs.hashValue
}


