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
    var bikeshop: String?
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
    
    
    // MARK: Hashable
    
    var hashValue: Int { return uid }
    
    
    // MARK: Convinience properties
    
    var membershipDuration: WSTimeInterval? {
        guard let created = created else { return nil }
        return timeIntervalSinceTime(created)
    }
    
    var lastLoggedInAgo: WSTimeInterval? {
        guard let login = login else { return nil }
        return timeIntervalSinceTime(login)
    }
    
    /** Returns an array of hosting info points applicable to the users profile. */
    var hostingInfo: [WSHostInfo] {
        var info = [WSHostInfo]()
        if maxcyclists != nil {
            let description = maxcyclists! > 4 ? "5 or more" : "\(maxcyclists!)"
            info.append(WSHostInfo(type: .MaxCyclists, description: description))
        }
        if bikeshop != nil {
            info.append(WSHostInfo(type: .BikeShop, description: bikeshop!))
        }
        if campground != nil {
            info.append(WSHostInfo(type: .Campground, description: campground!))
        }
        if motel != nil {
            info.append(WSHostInfo(type: .Motel, description: motel!))
        }
        return info
    }
    
    /** Returns an array of types of offers applicable to the users profile. */
    var offers: [WSOfferType] {
        var offers = [WSOfferType]()
        if bed ?? false { offers.append(.Bed) }
        if food ?? false { offers.append(.Food) }
        if laundry ?? false { offers.append(.Laundry) }
        if lawnspace ?? false { offers.append(.LawnSpace) }
        if sag ?? false { offers.append(.SAG) }
        if shower ?? false { offers.append(.Shower) }
        if storage ?? false { offers.append(.Storage) }
        if kitchenuse ?? false { offers.append(.KitchenUse) }
        return offers
    }
        
    /** Returns an array of tuples with phone number type and phone number. */
    var phoneNumbers: [WSPhoneNumber] {
        var phoneNumbers = [WSPhoneNumber]()
        if homephone ?? "" != "" {
            phoneNumbers.append(WSPhoneNumber(type: .Home, number: homephone!))
        }
        if mobilephone ?? "" != "" {
            phoneNumbers.append(WSPhoneNumber(type: .Mobile, number: mobilephone!))
        }
        if workphone ?? "" != "" {
            phoneNumbers.append(WSPhoneNumber(type: .Work, number: workphone!))
        }
        return phoneNumbers
    }
    
    /** The user address as a string with new line characters seperating the street, city, etc. */
    var address: String {
        var address: String = ""
        address.appendWithNewLine(street)
        address.appendWithNewLine(additional)
        address.appendWithNewLine(city)
        address.appendWithSpace(postal_code)
        if let country = country {
            address.appendWithNewLine(country.uppercaseString)
        }
        return address
    }
    
    
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
        bikeshop = String.fromJSON(json, withKey: "bikeshop")
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
    
}

func ==(lhs: WSUser, rhs: WSUser) -> Bool {
    return lhs.hashValue == rhs.hashValue
}


