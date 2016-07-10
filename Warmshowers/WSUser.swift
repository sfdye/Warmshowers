//
//  File.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 20/11/15.
//  Copyright © 2015 Rajan Fernandez. All rights reserved.
//

import UIKit

extension String {
    
    static func fromJSON(json: AnyObject, withKey key: String) -> String? {
        return json[key] as? String
    }
    
}

extension Double {
    
    static func fromJSON(json: AnyObject, withKey key: String) -> Double? {
        guard let valueString = String.fromJSON(json, withKey: key) else { return nil }
        return Double(valueString)
    }
    
}

extension Int {
    
    static func fromJSON(json: AnyObject, withKey key: String) -> Int? {
        guard let valueString = String.fromJSON(json, withKey: key) else { return nil }
        return Int(valueString)
    }
    
}

extension Bool {
    
    static func fromJSON(json: AnyObject, withKey key: String) -> Bool? {
        guard let valueString = String.fromJSON(json, withKey: key) else { return nil }
        return (valueString as NSString).boolValue
    }
    
}

class WSUser: Hashable {
    
    var fullname: String
    var name: String
    var uid: Int
    var isNotAvailable: Bool?
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
            let fullname = String.fromJSON(json, withKey: "fullname"),
            let name = String.fromJSON(json, withKey: "name"),
            let uid = Int.fromJSON(json, withKey: "uid")
            else {
                return nil
        }
        
        self.init(fullname: fullname, name: name, uid: uid)
        
        isNotAvailable = Bool.fromJSON(json, withKey:"notcurrentlyavailable")

//        if let created: NSTimeInterval = json["created"] as? String, let createdDouble = Double(created) {
//            joined = NSDate(timeIntervalSince1970: createdDouble)
//        }
//        
//        if let login: NSTimeInterval = json["login"] as? String, let loginDouble = Double(created) {
//            lastLoggedIn = NSDate(timeIntervalSince1970: loginDouble)
//        }

        comments = String.fromJSON(json, withKey: "comments")
        languagesSpoken = String.fromJSON(json, withKey: "languagesspoken")

        hostingInfo.update(json)
        offers.update(json)
        phoneNumbers.update(json)
        
        profileImageURL = String.fromJSON(json, withKey: "profile_image_mobile_profile_photo_std")
    }
}

func ==(lhs: WSUser, rhs: WSUser) -> Bool {
    return lhs.hashValue == rhs.hashValue
}


