//
//  WSUserLocationProtocol.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 8/05/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

protocol WSStoreUserLocationProtocol {
    
    /** Checks if a user is already in the store by uid. */
    func userLocationWithID(uid: Int) throws -> CDWSUserLocation?
    
    /** Returns an existing user, or a new user inserted into the private context. */
    func newOrExistingUserLocation(uid: Int) throws -> CDWSUserLocation
    
    /** Adds a user to the store with json describing a host location. */
    func addUserLocations(userLocations: [WSUserLocation], ToMapTile mapTile: CDWSMapTile) throws
}