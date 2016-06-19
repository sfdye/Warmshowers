//
//  WSHostsOnMapUpdater.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 25/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

// This class is for downloading hosts from warmshowers for a give map region
//
class WSHostsOnMapSearchManager : WSRequestWithCSRFToken, WSRequestDelegate {
    
    var x: UInt?
    var y: UInt?
    var z: UInt?
    let MapSearchLimit: Int = 500
    
    override init(success: (() -> Void)?, failure: ((error: NSError) -> Void)?) {
        super.init(success: success, failure: failure)
        requestDelegate = self
    }
    
    // Prevents the request starting without a CSRF token
    //
    override func shouldStart() -> Bool {
        
        guard token != nil else {
            setError(102, description: "Request aborted with no CSRF token.")
            return false
        }
        
        guard let _ = tileForUpdate() else {
            setError(502, description: "No map tile for request.")
            return false
        }
        
        return isReachable()
    }
    
    func requestForDownload() throws -> NSURLRequest {
        do {
            let service = WSRestfulService(type: .SearchByLocation)!
            var params = [String: String]() //tileForUpdate()!.getWSMapRegionLimits()
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
        
        WSStore.sharedStore.privateContext.performBlockAndWait {
            
            var tile: CDWSMapTile!
            do {
//                tile = try WSStore.newOrExistingMapTileAtPosition(self.x!, y: self.y!, z: self.z!)
            } catch let nserror as NSError {
                self.error = nserror
                return
            }
            
            print("got \(accounts.count) accounts")
            
            // Parse the json and add the users to the map tile
            for userLocationJSON in accounts {
                do {
//                    try WSStore.addUserToMapTile(tile, withLocationJSON:userLocationJSON)
                } catch let nserror as NSError {
                    self.error = nserror
                    return
                }
            }
            
            // Mark the tile as updated
            tile.setValue(NSDate(timeIntervalSinceNow: 0), forKey: "last_updated")
            print(tile.last_updated)
            do {
//                try store.savePrivateContext()
//                print("Successfully updated tile data")
            } catch let nserror as NSError {
                self.error = nserror
                return
            }
        }
    }
    
    // Convinience method to start the updates
    //
    func updateHostsForTileAtPosition(x: UInt, y: UInt, z: UInt) {
        self.x = x
        self.y = y
        self.z = z
        tokenGetter.start()
    }
    
    // Method to retrieve the updating tile from the store
    //
    func tileForUpdate() -> CDWSMapTile? {
        
//        guard let x = x, y = y, z = z else {
//            return nil
//        }
//        
//        do {
////            let tile = try store.mapTileAtPosition(x, y: y, z: z)
////            return tile
//        } catch {
//            print("Failed to retrieve tile from the store")
//            return nil
//        }
        return nil
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