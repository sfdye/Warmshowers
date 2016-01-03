//
//  HostingInfo.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 1/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

struct HostingInfo {
    
    var titleValues: [String] = [
        "Maximum Guests",
        "Nearest bike shop",
        "Nearest campground",
        "Nearest hotel/motel"
    ]
    var infoValues = [String?](count: 4, repeatedValue: nil)
    var count: Int {return titleValues.count}
    
    mutating func update(userData: AnyObject?) {
        
        guard let userData = userData else {
            return
        }
        
        var maxGuests = userData.valueForKey("maxcyclists") as? String
        maxGuests = (maxGuests == "5") ? "5 or more" : maxGuests
        let bikeshop = userData.valueForKey("bikeshop") as? String
        let campground = userData.valueForKey("campground") as? String
        let motel = userData.valueForKey("motel") as? String
        
        self.infoValues = [maxGuests, bikeshop, campground, motel]
    }
    
}