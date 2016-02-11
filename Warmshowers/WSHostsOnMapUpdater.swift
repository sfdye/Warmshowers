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
class WSHostsOnMapUpdater : WSRequestWithCSRFToken, WSRequestDelegate {
    
    var hostsOnMap: [WSUserLocation]!
    var mapView: MKMapView!
    let MapSearchLimit: Int = 800
    
    init(hostsOnMap: [WSUserLocation], mapView: MKMapView, success: (() -> Void)?, failure: ((error: NSError) -> Void)?) {
        super.init(success: success, failure: failure)
        requestDelegate = self
        self.hostsOnMap = hostsOnMap
        self.mapView = mapView
    }
    
    func requestForDownload() throws -> NSURLRequest {
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
        
        // Parse the json
        self.hostsOnMap = [WSUserLocation]()
        if let accounts = json["accounts"] as? NSArray {
            for account in accounts {
                if let user = WSUserLocation(json: account) {
                    self.hostsOnMap.append(user)
                }
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