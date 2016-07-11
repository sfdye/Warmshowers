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
    
    var url: String?
    var access: Int?
    var additional: String?
    var becomeavailable: Int?
    var bed: Bool?
    var bikeshop: Bool?
    var campground: String?
    var city: String?
    var comments: String?
    var country: String?
    var created: Int?
    var email_opt_out: Bool?
    var fax_number: Bool?
    var food: Bool?
    var fullname: String
    var hide_donation_status: Bool?
    var homephone: String?
    var kitchenuse: Bool?
    var language: String?
    var languagesspoken: String?
    var last_unavailability_pester: Int?
    var latitude: Double?
    var laundry: Bool?
    var lawnspace: Bool?
    var login: Int?
    var longitude: Double?
    var maxcyclists: Int?
    var mobilephone: String?
    var motel: String?
    var name: String
    var notcurrentlyavailable: Bool?
    var profileImageURL: String?
    var postal_code: String?
    var preferred_notice: String?
    var province: String?
    var sag: Bool?
    var set_available_timestamp: Int?
    var set_unavailable_timestamp: Int?
    var shower: Bool?
    var signature_format: Int?
    var source: Bool?
    var status: Bool?
    var storage: Bool?
    var street: String?
    var theme: String?
    var timezone: String?
    var uid: Int
    var workphone: String?
    
    var feedback: [WSRecommendation]?
    var profileImage: UIImage?
    
    var membershipDuration: WSTimeInterval? {
        guard let created = created else { return nil }
        return timeIntervalSinceTime(created)
    }
    
    var lastLoggedInAgo: WSTimeInterval? {
        guard let login = login else { return nil }
        return timeIntervalSinceTime(login)
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

        url = String.fromJSON(json, withKey: "URL")
        access = Int.fromJSON(json, withKey: "access")
        additional = String.fromJSON(json, withKey: "additional")
        becomeavailable = Int.fromJSON(json, withKey: "becomeavailable")
        bed = Bool.fromJSON(json, withKey: "bed")
        bikeshop = Bool.fromJSON(json, withKey: "bikeshop")
        campground = String.fromJSON(json, withKey: "campground")
        city = String.fromJSON(json, withKey: "city")
        comments = String.fromJSON(json, withKey: "comments")
        country = String.fromJSON(json, withKey: "country")
        created = Int.fromJSON(json, withKey: "created")
        email_opt_out = Bool.fromJSON(json, withKey: "email_opt_out")
        fax_number = Bool.fromJSON(json, withKey: "fax_number")
        food = Bool.fromJSON(json, withKey: "food")
        // fullname: parsed above
        hide_donation_status = Bool.fromJSON(json, withKey: "hide_donation_status")
        homephone = String.fromJSON(json, withKey: "homephone")
        kitchenuse = Bool.fromJSON(json, withKey: "kitchenuse")
        language = String.fromJSON(json, withKey: "language")
        languagesspoken = String.fromJSON(json, withKey: "languagesspoken")
        last_unavailability_pester = Int.fromJSON(json, withKey: "last_unavailability_pester")
        latitude = Double.fromJSON(json, withKey: "latitude")
        laundry = Bool.fromJSON(json, withKey: "laundry")
        lawnspace = Bool.fromJSON(json, withKey: "lawnspace")
        login = Int.fromJSON(json, withKey: "login")
        longitude = Double.fromJSON(json, withKey: "longitude")
        maxcyclists = Int.fromJSON(json, withKey: "maxcyclists")
        mobilephone = String.fromJSON(json, withKey: "mobilephone")
        motel = String.fromJSON(json, withKey: "motel")
        // name: parsed above
        notcurrentlyavailable = Bool.fromJSON(json, withKey:"notcurrentlyavailable")
        profileImageURL = String.fromJSON(json, withKey: "profile_image_mobile_profile_photo_std")
        postal_code = String.fromJSON(json, withKey: "postal_code")
        preferred_notice = String.fromJSON(json, withKey: "preferred_notice")
        province = String.fromJSON(json, withKey: "province")
        sag = Bool.fromJSON(json, withKey: "sag")
        set_available_timestamp = Int.fromJSON(json, withKey: "set_available_timestamp")
        set_unavailable_timestamp = Int.fromJSON(json, withKey: "set_unavailable_timestamp")
        shower = Bool.fromJSON(json, withKey: "shower")
        signature_format = Int.fromJSON(json, withKey: "signature_format")
        source = Bool.fromJSON(json, withKey: "source")
        status = Bool.fromJSON(json, withKey: "status")
        storage = Bool.fromJSON(json, withKey: "storage")
        street = String.fromJSON(json, withKey: "street")
        theme = String.fromJSON(json, withKey: "theme")
        timezone = String.fromJSON(json, withKey: "timezone")
        // uid: parsed above
        workphone = String.fromJSON(json, withKey: "workphone")
        
    }
    
    // MARK: Utility methods
    
    private func timeIntervalSinceTime(time: Int) -> WSTimeInterval {
        let date = NSDate(timeIntervalSince1970: NSTimeInterval(time))
        return WSTimeInterval(timeInterval: NSDate().timeIntervalSince1970 - date.timeIntervalSince1970)
    }
    
    var numberOfHostingInfo: Int {
        var count = 0
        if maxcyclists != nil { count += 1 }
        if bikeshop != nil { count += 1 }
        if campground != nil { count += 1 }
        if motel != nil { count += 1 }
        return count
    }
    
    var numberOfOffers: Int {
        var count = 0
        if bed ?? false { count += 1 }
        if food ?? false { count += 1 }
        if laundry ?? false { count += 1 }
        if lawnspace ?? false { count += 1 }
        if sag ?? false { count += 1 }
        if shower ?? false { count += 1 }
        if storage ?? false { count += 1 }
        if kitchenuse ?? false { count += 1 }
        return count
    }
    
    var numberOfPhoneNumbers: Int {
        var count = 0
        if homephone ?? "" != "" { count += 1 }
        if mobilephone ?? "" != "" { count += 1 }
        if workphone ?? "" != "" { count += 1 }
        return count
    }
    
}

func ==(lhs: WSUser, rhs: WSUser) -> Bool {
    return lhs.hashValue == rhs.hashValue
}


