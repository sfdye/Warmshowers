//
//  File.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 20/11/15.
//  Copyright © 2015 Rajan Fernandez. All rights reserved.
//

import Foundation

class WSUser {
    
    var URL: String? = nil
    var access: Int? = nil
    var additional: String? = nil
    var becomeavailable: Int? = nil
    var bed: Int? = nil
    var bikeshop: String? = nil
    var campground: String? = nil
    var city: String? = nil
    var comment_notify_settings: Dictionary<String, Int>? = ["comment_notify" : 1, "node_notify" : 1, "uid" : 0]
    var comments: String? = nil
    var country: String? = nil
    var created: Int? = nil
    var distance: Double? = nil;
    var email_opt_out: Int? = nil
    var fax_number: String? = nil
    var food: Bool = false
    var fullname: String? = nil
    var hide_donation_status: Bool = false;
    var homephone: String? = nil;
    var kitchenuse: Bool = false;
    var language: String? = nil
    var languagesspoken: String? = nil
    var last_unavailability_pester: Int? = nil
    var latitude: String? = nil
    var laundry: Bool = false
    var lawnspace: Bool = false
    var login: Int? = nil
    var longitude: String? = nil
    var maxcyclists: Int? = nil
    var mobilephone: String? = nil
    var motel: String? = nil
    var name: String = ""
    var notcurrentlyavailable: Bool = false
    var picture: String? = nil
    var postal_code: Int? = nil
    var preferred_notice: String? = nil
    var privatemsg_disabled: Bool = false
    var profile_image_map_infoWindow: String? = nil             // a small photo for map annotation thumbnails
    var profile_image_mobile_photo_456: String? = nil           // one size bigger
    var profile_image_mobile_profile_photo_std: String? = nil   // same but cropped to standard size
    var profile_image_profile_picture: String? = nil            // profile picture
    var province: String? = nil
    var sag: Bool = false
    var set_available_timestamp: Bool = false
    var set_unavailable_timestamp: Bool = false
    var shower: Bool = false
    var signature_format: Int? = nil
    var source: Int? = nil
    var status: Bool = false
    var storage: Bool = false
    var street: String? = nil
    var theme: String? = nil
    var timezone: String? = nil
    var uid: Int? = nil
    var workphone: String? = nil
    
//    init() {
//        
//    }
    
//    class func initWithDictionary(dict: [String: Any]) -> WSUser {
//        
//        let user = WSUser()
//        
//        let keys = dict.keys
//        for key in keys {
//            
//            
//        }
//        
//        return user
//    }
    
//    class func initWithJSONObject(json: AnyObject) {
//        self.init()
//        if self {
//            self.setWithJSONObject(json)
//        }
//    }
//    
//    func setWithJSONObject(json: AnyObject) {
//    
//    }
//    
//    func updateUserInfo() {
//        // download the user profile
//        httpClient.getUserInfo()
//        // update the profile
//        setWithJSONObject(json)
//    }

}
