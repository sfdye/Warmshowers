//
//  WSStore+UserLocation.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 29/03/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit
import CoreData

extension WSStore : WSStoreUserLocationProtocol {
    
    func userLocationWithID(uid: Int) throws -> CDWSUserLocation? {
        
        let request = requestForEntity(.UserLocation)
        request.predicate = NSPredicate(format: "uid == %i", uid)
        
        do {
            let user = try executeFetchRequest(request).first as? CDWSUserLocation
            return user
        }
    }
    
    func newOrExistingUserLocation(uid: Int) throws -> CDWSUserLocation {
        do {
            if let user = try userLocationWithID(uid) {
                return user
            } else {
                let user = NSEntityDescription.insertNewObjectForEntityForName(WSEntity.UserLocation.rawValue, inManagedObjectContext: privateContext) as! CDWSUserLocation
                return user
            }
        }
    }
    
    func addUserLocations(userLocations: [WSUserLocation], ToMapTile mapTile: CDWSMapTile) throws {
        
        for userLocation in userLocations {
            do {
                let user = try newOrExistingUserLocation(userLocation.uid)
                // Critical properties
                user.fullname = userLocation.fullname
                user.name = userLocation.name
                user.uid = userLocation.uid
                user.latitude = userLocation.latitude
                user.longitude = userLocation.longitude
                // Other Properties
                user.additional = userLocation.additional
                user.city = userLocation.city
                user.country = userLocation.country
                user.distance = userLocation.distance
                user.notcurrentlyavailable = userLocation.notcurrentlyavailable
                user.post_code = userLocation.postCode
                user.province = userLocation.province
                user.image_url = userLocation.imageURL
                user.street = userLocation.street
                user.map_tile = mapTile
            }
        }
    }
    
}
