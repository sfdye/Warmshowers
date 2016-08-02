//
//  WSSearchByLocationEndPoint.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 9/05/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

class WSSearchByLocationEndPoint : WSAPIEndPointProtocol {
    
    static let MapSearchLimit: Int = 500
    
    var type: WSAPIEndPoint = .SearchByLocation
    
    var httpMethod: HttpMethod = .Post
    
    func urlWithHostURL(hostURL: NSURL, andParameters parameters: AnyObject?) throws -> NSURL {
        return hostURL.URLByAppendingPathComponent("/services/rest/hosts/by_location")
    }
    
    func HTTPBodyParametersWithData(data: AnyObject?) throws -> [String: String] {
        guard data is WSMapTile else { throw WSAPIEndPointError.InvalidOutboundData }
        var params = (data as! WSMapTile).regionLimits
        params["limit"] = String(WSSearchByLocationEndPoint.MapSearchLimit)
        return params
    }
    
    func request(request: WSAPIRequest, updateStore store: WSStoreProtocol, withJSON json: AnyObject) throws {
        
        guard let quadKey = (request.data as? WSMapTile)?.quadKey else {
            throw WSAPIEndPointError.InvalidOutboundData
        }
        
        guard let accountsJSON = json["accounts"] as? [AnyObject] else {
            throw WSAPIEndPointError.ParsingError(endPoint: name, key: "accounts")
        }
        
        guard accountsJSON.count < 500 else {
            throw WSAPIEndPointError.ReachedTileLimit
        }
        
        do {
            try store.performBlockInPrivateContextAndWait({ (context) in
                
                let tile = try store.newOrExisting(WSMOMapTile.self, withJSON: ["quad_key": quadKey], context: context)
                tile.last_updated = NSDate()
                tile.quad_key = quadKey
                
                // Link the map tile to its parent tile if neccessary
                let index = quadKey.endIndex.advancedBy(-1)
                let parentQuadKey = quadKey.substringToIndex(index)
                
                let predicate = NSPredicate(format: "quad_key == %@", parentQuadKey)
                if let parentTile = try! store.retrieve(WSMOMapTile.self, sortBy: nil, isAscending: true, predicate: predicate, context: context).first {
                    tile.parent_tile = parentTile
                }
                
                var users = Set<WSMOUser>()
                for accountJSON in accountsJSON {
                    let user = try store.newOrExisting(WSMOUser.self, withJSON: accountJSON, context: context)
                    users.insert(user)
                }
                tile.users = users
                
                try context.save()
                try store.managedObjectContext.save()
            })
        }
    }
    
}