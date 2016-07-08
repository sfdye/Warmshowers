//
//  WSLocationSearchViewController+WSAPIResponseDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 11/05/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

extension WSLocationSearchViewController : WSAPIResponseDelegate {
    
    func request(request: WSAPIRequest, didSuceedWithData data: AnyObject?) {
        
        if let users = data as? [WSUserLocation] {
            
            guard
                let centerLatitude = request.params?["centerlat"],
                let centerLongitude = request.params?["centerlon"],
                let latitude = Double(centerLatitude),
                let longitude = Double(centerLongitude),
                let tile = WSMapTile(latitude: latitude, longitude: longitude, zoom: TileUpdateZoomLevel)
                else {
                    // handle error
                    return
            }

            undimTile(tile)
            storeUsers(users, onMapTileWithQuadKey: tile.quadKey)
            addUsersToMap(users)
        }
    }
    
    func request(request: WSAPIRequest, didFailWithError error: ErrorType) {
        alert.presentAPIError(error, forDelegator: self)
    }
    
    // LEAVE HERE FOR NOW. SHOULD REALLY BE MOVED TO A DATA DELEGATES RESPONSBILITY
    func storeUsers(users: [WSUserLocation], onMapTileWithQuadKey quadKey: String) {
        
        var error: ErrorType? = nil
        WSStore.sharedStore.privateContext.performBlockAndWait {
            
            var tile: CDWSMapTile!
            do {
                tile = try WSStore.sharedStore.newOrExistingMapTileWithQuadKey(quadKey)
                do {
                    try WSStore.sharedStore.addUserLocations(users, ToMapTile: tile)
                }
                tile.setValue(NSDate(), forKey: "last_updated")
                try WSStore.sharedStore.savePrivateContext()
            } catch let storeError {
                error = storeError
                return
            }
        }
        
    }
}
