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
                let tile = WSMapTile(latitude: latitude, longitude: longitude, zoom: 4)
                else {
                    // handle error
                    return
            }
            
            print("\(users.count) hosts recieved for tile with key \(tile.quadKey)")
            storeUsers(users, onMapTileWithQuadKey: tile.quadKey)
            addUsersToMap(users)
        }
    }
    
    func request(request: WSAPIRequest, didFailWithError error: ErrorType) {
        alertDelegate.presentAPIError(error, forDelegator: self)
    }
}
