//
//  WSGetHostsForKeywordOperation.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 16/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

class WSGetHostsForKeywordOperation : NSOperation {
    
    var keyword: String!
    var success: ((hosts: [WSUserLocation]) -> Void)?
    var failure: (() -> Void)?
    
    init(keyword: String) {
        self.keyword = keyword
        super.init()
    }
    
    override func main() {
        
//        // Get the new search results
//        WSRequest.getHostDataForKeyword(keyword, offset: 0) { (data) -> Void in
//            
//            // About if the operation was cancelled
//            guard self.cancelled == false else {
//                return
//            }
//            
//            // Update the tableView data source
//            if let data = data {
//                
//                var hosts = [WSUserLocation]()
//                
//                // parse the json
//                if let json = WSRequest.jsonDataToDictionary(data) {
//                    if let accounts = json["accounts"] as? NSDictionary {
//                        for (_, account) in accounts {
//                            if let user = WSUserLocation(json: account) {
//                                hosts.append(user)
//                            }
//                        }
//                    }
//                }
//                
//                if self.cancelled == false {
//                    self.success?(hosts: hosts)
//                }
//            }
//            self.failure?()
//        }
    }
    
}

//    EXAMPLE JSON FOR USER OBJECT
//    {
//    URL = "";
//    access = 1421382979;
//    additional = "Sinhagad Road";
//    becomeavailable = 1419577200;
//    bed = 1;
//    bikeshop = 200m;
//    campground = "no campgrounds in India";
//    city = Pune;
//    "comment_notify_settings" =     {
//    "comment_notify" = 1;
//    "node_notify" = 1;
//    uid = 122;
//    };
//    comments = "I and my wife, Shiwanee will be happy to host you. starting from finding your way into town, we can help you with planning hiking/biking excursions in the nearby hills, plan any other tours in our state, book tickets, help with logistics etc.
//    \nWe are both employed in the computer software industry. Hosting is not our business. We do it only because we think it is our duty towards fellow tourers.";
//    country = in;
//    created = 1020060000;
//    "email_opt_out" = 0;
//    "fax_number" = "";
//    food = 1;
//    fullname = "Sujay N. Patankar";
//    "hide_donation_status" = "<null>";
//    homephone = "+91-20-24308058";
//    howdidyouhear = "Touring list on phred.org";
//    kitchenuse = 1;
//    language = "en-working";
//    languagesspoken = "English, Marathi, Hindi";
//    "last_unavailability_pester" = 0;
//    latitude = "18.492674";
//    laundry = 1;
//    lawnspace = 0;
//    login = 1421382979;
//    longitude = "73.833532";
//    maxcyclists = 2;
//    mobilephone = "+91-9881071197";
//    motel = "2 Km";
//    name = "thepunekar@yahoo.com";
//    notcurrentlyavailable = 0;
//    picture =     {
//    fid = 130548;
//    filemime = "image/jpeg";
//    filename = "picture-122.jpg";
//    filesize = 17956;
//    status = 1;
//    timestamp = 1444780947;
//    uid = 122;
//    uri = "public://pictures/picture-122.jpg";
//    };
//    "postal_code" = 411030;
//    "preferred_notice" = asap;
//    "profile_image_map_infoWindow" = "https://www.warmshowers.org/files/styles/map_infoWindow/public/pictures/picture-122.jpg?itok=5jf5hr3T";
//    "profile_image_mobile_photo_456" = "https://www.warmshowers.org/files/styles/mobile_photo_456/public/pictures/picture-122.jpg?itok=d_J4Kkg8";
//    "profile_image_mobile_profile_photo_std" = "https://www.warmshowers.org/files/styles/mobile_profile_photo_std/public/pictures/picture-122.jpg?itok=oB3VzV-W";
//    "profile_image_profile_picture" = "https://www.warmshowers.org/files/styles/profile_picture/public/pictures/picture-122.jpg?itok=h4VyrE9N";
//    province = mm;
//    sag = 1;
//    "set_available_timestamp" = 0;
//    "set_unavailable_timestamp" = 0;
//    shower = 1;
//    signature = "";
//    "signature_format" = 1;
//    source = 1;
//    status = 1;
//    storage = 1;
//    street = "15, Vastushree, Behind IBP Petrol Pump,";
//    theme = "";
//    timezone = "Asia/Kolkata";
//    uid = 122;
//    workphone = "+91-20-42003150";
//}
