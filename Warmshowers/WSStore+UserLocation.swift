//
//  WSStore+UserLocation.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 29/03/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit
import CoreData

extension WSStore {
    
    // Checks if a user is already in the store by uid.
    //
    class func userLocationWithID(uid: Int) throws -> CDWSUserLocation? {
        
        let request = requestForEntity(.UserLocation)
        request.predicate = NSPredicate(format: "uid == %i", uid)
        
        do {
            let user = try executeFetchRequest(request).first as? CDWSUserLocation
            return user
        }
    }
    
    // Returns an existing user, or a new user inserted into the private context.
    //
    class func newOrExistingUserLocation(uid: Int) throws -> CDWSUserLocation {
        do {
            if let user = try userLocationWithID(uid) {
                return user
            } else {
                let user = NSEntityDescription.insertNewObjectForEntityForName(WSEntity.UserLocation.rawValue, inManagedObjectContext: sharedStore.privateContext) as! CDWSUserLocation
                return user
            }
        }
    }
    
    // Adds a user to the store with json describing a host location
    //
    class func addUserToMapTile(mapTile: CDWSMapTile, withLocationJSON json: AnyObject) throws {
        
        guard let fullname = json.valueForKey("fullname") as? String else {
            throw CDWSUserLocationError.FailedValueForKey(key: "fullname")
        }
        
        guard let name = json.valueForKey("name") as? String else {
            throw CDWSUserLocationError.FailedValueForKey(key: "name")
        }
        
        guard let uid = json.valueForKey("uid")?.integerValue else {
            throw CDWSUserLocationError.FailedValueForKey(key: "uid")
        }
        
        guard let latitude = json.valueForKey("latitude")?.doubleValue else {
            throw CDWSUserLocationError.FailedValueForKey(key: "latitude")
        }
        
        guard let longitude = json.valueForKey("longitude")?.doubleValue else {
            throw CDWSUserLocationError.FailedValueForKey(key: "longitude")
        }
        
        do {
            let user = try newOrExistingUserLocation(uid)
            // Critical properties
            user.fullname = fullname
            user.name = name
            user.uid = uid
            user.latitude = latitude
            user.longitude = longitude
            // Other Properties
            user.additional = json.valueForKey("additional") as? String
            user.city = json.valueForKey("city") as? String
            user.country = json.valueForKey("country") as? String
            user.distance = json.valueForKey("distance")?.doubleValue
            user.notcurrentlyavailable = json.valueForKey("notcurrentlyavailable")?.boolValue
            user.post_code = json.valueForKey("postal_code") as? String
            user.province = json.valueForKey("province") as? String
            user.image_url = json.valueForKey("profile_image_map_infoWindow") as? String
            user.street = json.valueForKey("street") as? String
            user.map_tile = mapTile
        }
    }
    
}
