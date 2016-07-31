//
//  WSSearchByLocationEndPoint.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 9/05/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

class WSSearchByLocationEndPoint : WSAPIEndPointProtocol {
    
    let MapSearchLimit: Int = 500
    
    var type: WSAPIEndPoint = .SearchByLocation
    
    var httpMethod: HttpMethod = .Post
    
    func urlWithHostURL(hostURL: NSURL, andParameters parameters: AnyObject?) throws -> NSURL {
        return hostURL.URLByAppendingPathComponent("/services/rest/hosts/by_location")
    }
    
    func HTTPBodyParametersWithData(data: AnyObject?) throws -> [String: String] {
        guard data is WSMapTile else { throw WSAPIEndPointError.InvalidOutboundData }
        var params = (data as! WSMapTile).regionLimits
        params["limit"] = String(MapSearchLimit)
        return params
    }
    
//    func request(request: WSAPIRequest, didRecieveResponseWithJSON json: AnyObject) throws -> AnyObject? {
//        
//        guard let quadKey = (request.data as? WSMapTile)?.quadKey else {
//            throw WSAPIEndPointError.InvalidOutboundData
//        }
//        
//        guard let accounts = json["accounts"] as? NSArray else {
//            throw WSAPIEndPointError.ParsingError(endPoint: name, key: "accounts")
//        }
//        
//        var userLocations = [WSUserLocation]()
//        for account in accounts {
//            if let userLocation = WSUserLocation(json: account) {
//                userLocations.append(userLocation)
//            } else {
//                throw WSAPIEndPointError.ParsingError(endPoint: name, key: nil)
//            }
//        }
//        
//        let store = WSStore.sharedStore
//        var error: ErrorType?
//        WSStore.sharedStore.privateContext.performBlockAndWait {
//            
//            var tile: WSMOMapTile!
//            do {
//                tile = try store.newOrExistingMapTileWithQuadKey(quadKey)
//                do {
//                    try store.addUserLocations(userLocations, ToMapTile: tile)
//                }
//                tile.setValue(NSDate(), forKey: "last_updated")
//                try WSStore.sharedStore.savePrivateContext()
//            } catch let storeError {
//                error = storeError
//                return
//            }
//        }
//        
//        if error != nil { throw error! }
//        
//        return userLocations
//    }
    
    func request(request: WSAPIRequest, updateStore store: WSStoreProtocol, withJSON json: AnyObject) throws {
        
//        guard let quadKey = (request.data as? WSMapTile)?.quadKey else {
//            throw WSAPIEndPointError.InvalidOutboundData
//        }
//        
//        guard let accounts = json["accounts"] as? NSArray else {
//            throw WSAPIEndPointError.ParsingError(endPoint: name, key: "accounts")
//        }
//        
//        guard accounts.count < 500 else {
//            throw WSAPIEndPointError.ReachedTileLimit
//        }
//        
//        var userLocations = [WSUserLocation]()
//        for account in accounts {
//            if let userLocation = WSUserLocation(json: account) {
//                userLocations.append(userLocation)
//            } else {
//                throw WSAPIEndPointError.ParsingError(endPoint: name, key: nil)
//            }
//        }
//        
//        var error: ErrorType?
//        WSStore.sharedStore.privateContext.performBlockAndWait {
//            
//            var tile: WSMOMapTile!
//            do {
//                tile = try store.newOrExistingMapTileWithQuadKey(quadKey)
//                do {
//                    try store.addUserLocations(userLocations, ToMapTile: tile)
//                }
//                tile.setValue(NSDate(), forKey: "last_updated")
//                try WSStore.sharedStore.savePrivateContext()
//            } catch let storeError {
//                error = storeError
//                return
//            }
//        }
//        
//        if error != nil { throw error! }
    }
    
}