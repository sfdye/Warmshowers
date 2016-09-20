//
//  WSSearchByLocationEndPoint.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 9/05/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

class WSSearchByLocationEndPoint: WSAPIEndPointProtocol {
    
    static let MapSearchLimit: Int = 800
    
    var type: WSAPIEndPoint = .SearchByLocation
    
    var httpMethod: HttpMethod = .Post
    
    func url(withHostURL hostURL: URL, andParameters parameters: Any?) throws -> URL {
        return hostURL.appendingPathComponent("/services/rest/hosts/by_location")
    }
    
    func HTTPBodyParameters(withData data: Any?) throws -> [String: String] {
        guard data is WSMapTile else { throw WSAPIEndPointError.invalidOutboundData }
        var params = (data as! WSMapTile).regionLimits
        params["limit"] = String(WSSearchByLocationEndPoint.MapSearchLimit)
        return params
    }
    
    func request(_ request: WSAPIRequest, updateStore store: WSStoreProtocol, withJSON json: Any) throws {
        
        guard let quadKey = (request.data as? WSMapTile)?.quadKey else {
            throw WSAPIEndPointError.invalidOutboundData
        }
        
        guard let json = json as? [String: Any] else {
            throw WSAPIEndPointError.parsingError(endPoint: name, key: nil)
        }
        
        guard let accountsJSON = json["accounts"] as? [AnyObject] else {
            throw WSAPIEndPointError.parsingError(endPoint: name, key: "accounts")
        }
        
        // If the API has returned the maximum number of hosts, save the map tile and link it to its parent, then throw an error so that to WSLocationSearchViewController can initate loading the subtiles for this tile.
        guard accountsJSON.count < WSSearchByLocationEndPoint.MapSearchLimit else {
            
//            do {
//                try store.performBlockInPrivateContextAndWait({ (context) in
//                    
//                    let tile: WSMOMapTile = try store.newOrExisting(WSMOMapTile, withJSON: ["quad_key": quadKey], context: context)
//                    tile.last_updated = Date()
//                    tile.quad_key = quadKey
//                    
//                    // Link the map tile to its parent tile if neccessary
//                    let index = quadKey.characters.index(quadKey.endIndex, offsetBy: -1)
//                    let parentQuadKey = quadKey.substring(to: index)
//                    
//                    let predicate = NSPredicate(format: "quad_key == %@", parentQuadKey)
//                    if let parentTile = try! store.retrieve(WSMOMapTile.self, sortBy: nil, isAscending: true, predicate: predicate, context: context).first {
//                        tile.parent_tile = parentTile
//                    }
//                    
//                    try context.save()
//                })
//            }
            
            throw WSAPIEndPointError.reachedTileLimit
        }
        
        do {
            try store.performBlockInPrivateContextAndWait({ (context) in
                
//                let tile: WSMOMapTile = try store.newOrExisting(WSMOMapTile, withJSON: ["quad_key": quadKey], context: context)
//                tile.last_updated = Date()
//                tile.quad_key = quadKey
//                
//                // Link the map tile to its parent tile if neccessary
//                let index = quadKey.characters.index(quadKey.endIndex, offsetBy: -1)
//                let parentQuadKey = quadKey.substring(to: index)
//                
//                let predicate = NSPredicate(format: "quad_key == %@", parentQuadKey)
//                if let parentTile = try! store.retrieve(WSMOMapTile.self, sortBy: nil, isAscending: true, predicate: predicate, context: context).first {
//                    tile.parent_tile = parentTile
//                }
//                
//                var users = Set<WSMOUser>()
//                for accountJSON in accountsJSON {
//                    let user = try store.newOrExisting(WSMOUser.self, withJSON: accountJSON, context: context)
//                    users.insert(user)
//                }
//                tile.users = users as NSSet?
//                
//                try context.save()
            })
        }
    }
    
}
