//
//  WSHostsOnMapUpdater.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 25/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

// This class is for downloading hosts from warmshowers for a give map region
//
class WSHostsOnMapSearchManager : WSRequestWithCSRFToken, WSRequestDelegate {
    
    var store: WSStore!
    var mapView: MKMapView!
    let MapSearchLimit: Int = 800
    
    init(store: WSStore, mapView: MKMapView, success: (() -> Void)?, failure: ((error: NSError) -> Void)?) {
        super.init(success: success, failure: failure)
        requestDelegate = self
        self.store = store
        self.mapView = mapView
    }
    
    func requestForDownload() throws -> NSURLRequest {
        
        // DECIDE WHAT AREAS TO REQUEST HERE
        // ACCESS THE STORE AND CHECK WHICH AREAS NEED UPDATEING
        
        
        do {
            let service = WSRestfulService(type: .SearchByLocation)!
            var params = mapView.getWSMapRegion()
            params["limit"] = String(MapSearchLimit)
            let request = try WSRequest.requestWithService(service, params: params, token: token)
            return request
        }
    }
    
    func doWithData(data: NSData) {
        
        guard let json = dataAsJSON() else {
            return
        }
        
        guard let accounts = json["accounts"] as? NSArray else {
            setError(501, description: "Failed find accounts in host location JSON.")
            return
        }
        
        // Parse the json
        for userLocationJSON in accounts {
            do {
                try self.store.addUserWithLocationJSON(userLocationJSON)
                print("user saved to store")
            } catch let nserror as NSError {
                self.error = nserror
                return
            }
        }
    }
    
    // Convinience method to start the updates
    //
    func update() {
        tokenGetter.start()
    }

}

// EXAMPLE JSON FOR USER LOCATION OBJECTS
//    {
//    access = 1424441219;
//    city = Caracas;
//    country = ve;
//    created = 1360693669;
//    distance = "1589.2337810280335";
//    fullname = "Ximena Carrasco";
//    latitude = "10.491016";
//    login = 1424441033;
//    longitude = "-66.902061";
//    name = "Mena Carrasco";
//    notcurrentlyavailable = 0;
//    picture = 142728;
//    position = "10.491016,-66.902061";
//    "postal_code" = 1011;
//    "profile_image_map_infoWindow" = "https://www.warmshowers.org/files/styles/map_infoWindow/public/pictures/picture-42795.jpg?itok=YdnATdzn";
//    "profile_image_mobile_photo_456" = "https://www.warmshowers.org/files/styles/mobile_photo_456/public/pictures/picture-42795.jpg?itok=ti5zeS1Y";
//    "profile_image_mobile_profile_photo_std" = "https://www.warmshowers.org/files/styles/mobile_profile_photo_std/public/pictures/picture-42795.jpg?itok=dQL6cIAv";
//    "profile_image_profile_picture" = "https://www.warmshowers.org/files/styles/profile_picture/public/pictures/picture-42795.jpg?itok=xdkN20GR";
//    province = a;
//    source = 5;
//    street = "";
//    uid = 42795;
//    }