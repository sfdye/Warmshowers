//
//  File.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 20/11/15.
//  Copyright © 2015 Rajan Fernandez. All rights reserved.
//

import UIKit

public class User: Hashable {
    
    var url: String?
    var access: Int?
    var additional: String?
    var becomeavailable: Int?
    var bed: Bool?
    var bikeshop: String?
    var campground: String?
    var city: String?
    public var comments: String?
    var country: String?
    var created: Int?
    var email_opt_out: Bool?
    var fax_number: Bool?
    var food: Bool?
    public var fullname: String
    var hide_donation_status: Bool?
    var homephone: String?
    var kitchenuse: Bool?
    var language: String?
    public var languagesspoken: String?
    var last_unavailability_pester: Int?
    var latitude: Double?
    var laundry: Bool?
    var lawnspace: Bool?
    var login: Int?
    var longitude: Double?
    var maxcyclists: Int?
    var mobilephone: String?
    var motel: String?
    public var name: String
    public var notcurrentlyavailable: Bool?
    public var profileImageURL: String?
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
    public var uid: Int
    var workphone: String?
    
    public var feedback: [Recommendation]?
    public var profileImage: UIImage?
    
    
    // MARK: Hashable
    
    public var hashValue: Int { return uid }
    
    
    // MARK: Convinience properties
    
    public var membershipDuration: Int? {
        guard let created = created else { return nil }
        return timeIntervalSinceTime(created)
    }
    
    public var lastLoggedInAgo: Int? {
        guard let login = login else { return nil }
        return timeIntervalSinceTime(login)
    }
    
    /** Returns an array of hosting info points applicable to the users profile. */
    public var hostingInfo: [HostInfo] {
        var info = [HostInfo]()
        if let maxcyclists = maxcyclists {
            let description = maxcyclists > 4 ? "5+" : "\(maxcyclists)"
            info.append(HostInfo(type: .maxCyclists, description: description))
        }
        if let bikeshop = bikeshop {
            info.append(HostInfo(type: .bikeShop, description: bikeshop))
        }
        if let campground = campground {
            info.append(HostInfo(type: .campground, description: campground))
        }
        if let motel = motel {
            info.append(HostInfo(type: .motel, description: motel))
        }
        return info
    }
    
    /** Returns an array of types of offers applicable to the users profile. */
    public var offers: [OfferType] {
        var offers = [OfferType]()
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
    public var phoneNumbers: [PhoneNumber] {
        var phoneNumbers = [PhoneNumber]()
        if homephone ?? "" != "" {
            phoneNumbers.append(PhoneNumber(type: .home, number: homephone!))
        }
        if mobilephone ?? "" != "" {
            phoneNumbers.append(PhoneNumber(type: .mobile, number: mobilephone!))
        }
        if workphone ?? "" != "" {
            phoneNumbers.append(PhoneNumber(type: .work, number: workphone!))
        }
        return phoneNumbers
    }
    
    /** The user address as a string with new line characters seperating the street, city, etc. */
    public var address: String {
        var address: String = ""
        address.appendWithNewLine(street)
        address.appendWithNewLine(additional)
        address.appendWithNewLine(city)
        address.appendWithSpace(postal_code)
        if let country = country {
            address.appendWithNewLine(country.uppercased())
        }
        return address
    }
    
    
    // MARK: Initialisers
    
    init(fullname: String, name: String, uid: Int) {
        self.fullname = fullname
        self.name = name
        self.uid = uid
    }
    
    convenience init?(json: Any) {
        
        guard let json = json as? [String: Any] else { return nil }
        
        guard
            let fullname = String.from(JSON: json, withKey: "fullname"),
            let name = String.from(JSON: json, withKey: "name"),
            let uid = Int.from(JSON: json, withKey: "uid")
            else {
                return nil
        }
        
        self.init(fullname: fullname, name: name, uid: uid)

        url = String.from(JSON: json, withKey: "URL")
        access = Int.from(JSON: json, withKey: "access")
        additional = String.from(JSON: json, withKey: "additional")
        becomeavailable = Int.from(JSON: json, withKey: "becomeavailable")
        bed = Bool.from(JSON: json, withKey: "bed")
        bikeshop = String.from(JSON: json, withKey: "bikeshop")
        campground = String.from(JSON: json, withKey: "campground")
        city = String.from(JSON: json, withKey: "city")
        comments = String.from(JSON: json, withKey: "comments")
        country = String.from(JSON: json, withKey: "country")
        created = Int.from(JSON: json, withKey: "created")
        email_opt_out = Bool.from(JSON: json, withKey: "email_opt_out")
        fax_number = Bool.from(JSON: json, withKey: "fax_number")
        food = Bool.from(JSON: json, withKey: "food")
        // fullname: parsed above
        hide_donation_status = Bool.from(JSON: json, withKey: "hide_donation_status")
        homephone = String.from(JSON: json, withKey: "homephone")
        kitchenuse = Bool.from(JSON: json, withKey: "kitchenuse")
        language = String.from(JSON: json, withKey: "language")
        languagesspoken = String.from(JSON: json, withKey: "languagesspoken")
        last_unavailability_pester = Int.from(JSON: json, withKey: "last_unavailability_pester")
        latitude = Double.from(JSON: json, withKey: "latitude")
        laundry = Bool.from(JSON: json, withKey: "laundry")
        lawnspace = Bool.from(JSON: json, withKey: "lawnspace")
        login = Int.from(JSON: json, withKey: "login")
        longitude = Double.from(JSON: json, withKey: "longitude")
        maxcyclists = Int.from(JSON: json, withKey: "maxcyclists")
        mobilephone = String.from(JSON: json, withKey: "mobilephone")
        motel = String.from(JSON: json, withKey: "motel")
        // name: parsed above
        notcurrentlyavailable = Bool.from(JSON: json, withKey:"notcurrentlyavailable")
        profileImageURL = String.from(JSON: json, withKey: "profile_image_mobile_profile_photo_std")
        postal_code = String.from(JSON: json, withKey: "postal_code")
        preferred_notice = String.from(JSON: json, withKey: "preferred_notice")
        province = String.from(JSON: json, withKey: "province")
        sag = Bool.from(JSON: json, withKey: "sag")
        set_available_timestamp = Int.from(JSON: json, withKey: "set_available_timestamp")
        set_unavailable_timestamp = Int.from(JSON: json, withKey: "set_unavailable_timestamp")
        shower = Bool.from(JSON: json, withKey: "shower")
        signature_format = Int.from(JSON: json, withKey: "signature_format")
        source = Bool.from(JSON: json, withKey: "source")
        status = Bool.from(JSON: json, withKey: "status")
        storage = Bool.from(JSON: json, withKey: "storage")
        street = String.from(JSON: json, withKey: "street")
        theme = String.from(JSON: json, withKey: "theme")
        timezone = String.from(JSON: json, withKey: "timezone")
        // uid: parsed above
        workphone = String.from(JSON: json, withKey: "workphone")
        
    }
    
    // MARK: Utility methods
    
    fileprivate func timeIntervalSinceTime(_ time: Int) -> Int {
        let date = Date(timeIntervalSince1970: TimeInterval(time))
        return Int(Date().timeIntervalSince1970 - date.timeIntervalSince1970)
    }
    
}

public func ==(lhs: User, rhs: User) -> Bool {
    return lhs.hashValue == rhs.hashValue
}


