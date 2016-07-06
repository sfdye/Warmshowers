//
//  WSHostingInfo.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 1/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

struct WSHostingInfo {
    
    var titleValues: [String] = [
        "Maximum Guests",
        "Nearest bike shop",
        "Nearest campground",
        "Nearest hotel/motel"
    ]
    var infoValues = [String?](repeating: nil, count: 4)
    var count: Int {return titleValues.count}
    
    mutating func update(_ userData: AnyObject?) {
        
        guard let userData = userData else {
            return
        }
        
        var maxGuests = userData.value(forKey: "maxcyclists") as? String
        maxGuests = (maxGuests == "5") ? "5 or more" : maxGuests
        let bikeshop = userData.value(forKey: "bikeshop") as? String
        let campground = userData.value(forKey: "campground") as? String
        let motel = userData.value(forKey: "motel") as? String
        
        self.infoValues = [maxGuests, bikeshop, campground, motel]
    }
    
}
