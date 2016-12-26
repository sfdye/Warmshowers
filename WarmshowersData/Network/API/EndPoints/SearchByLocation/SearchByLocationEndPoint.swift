//
//  SearchByLocationEndPoint.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 9/05/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

class SearchByLocationEndPoint: APIEndPointProtocol {
    
    static let MapSearchLimit: Int = 800
    
    var type: APIEndPoint = .searchByLocation
    
    func url(withHostURL hostURL: URL, andParameters parameters: Any?) throws -> URL {
        return hostURL.appendingPathComponent("/services/rest/hosts/by_location")
    }
    
    func httpBody(fromData data: Any?, forMethod method: HTTP.Method, withEncoder encoder: APIRequestDataEncoder) throws -> Data? {
        
        guard let mapTile = data as? MapTile else {
            throw APIEndPointError.invalidOutboundData(endPoint: name, errorDescription: "The \(name) end point requires a map tile in the request data.")
        }
        
        var params = mapTile.regionLimits
        params["limit"] = String(SearchByLocationEndPoint.MapSearchLimit)
        let body = try encoder.body(fromParameters: params)
        return body
    }
    
    func request(_ request: APIRequest, updateStore store: StoreUpdateDelegate, withJSON json: Any, parser: JSONParser) throws {
        
        guard let quadKey = (request.data as? MapTile)?.quadKey else {
            throw APIEndPointError.invalidOutboundData(endPoint: name, errorDescription: "The \(name) end point requires a map tile quad key.")
        }
        
        guard let json = json as? [String: Any] else {
            throw APIEndPointError.parsingError(endPoint: name, key: nil)
        }
        
        guard let accountsJSON = json["accounts"] as? [Any] else {
            throw APIEndPointError.parsingError(endPoint: name, key: "accounts")
        }
        
        // If the API has returned the maximum number of hosts, save the map tile and link it to its parent, then throw an error so that to LocationSearchViewController can initate loading the subtiles for this tile.
        guard accountsJSON.count < SearchByLocationEndPoint.MapSearchLimit else {
            
            try store.performBlockInPrivateContextAndWait({ (context) in
                
                let tile: MOMapTile = try store.newOrExisting(inContext: context, withJSON: ["quad_key": quadKey], withParser: parser)
                tile.last_updated = Date()
                tile.quad_key = quadKey
                
                // Link the map tile to its parent tile if neccessary
                let index = quadKey.characters.index(quadKey.endIndex, offsetBy: -1)
                let parentQuadKey = quadKey.substring(to: index)
                
                let predicate = NSPredicate(format: "quad_key == %@", parentQuadKey)
                if let parentTile: MOMapTile = try! store.retrieve(inContext: context, withPredicate: predicate, andSortBy: nil, isAscending: true).first {
                    tile.parent_tile = parentTile
                }
                
                try context.save()
            })
            
            
            throw APIEndPointError.reachedTileLimit
        }
        
        
        try store.performBlockInPrivateContextAndWait({ (context) in
            
            let tile: MOMapTile = try store.newOrExisting(inContext: context, withJSON: ["quad_key": quadKey], withParser: parser)
            tile.last_updated = Date()
            tile.quad_key = quadKey
            
            // Link the map tile to its parent tile if neccessary
            let index = quadKey.characters.index(quadKey.endIndex, offsetBy: -1)
            let parentQuadKey = quadKey.substring(to: index)
            
            let predicate = NSPredicate(format: "quad_key == %@", parentQuadKey)
            if let parentTile: MOMapTile = try! store.retrieve(inContext: context, withPredicate: predicate, andSortBy: nil, isAscending: true).first {
                tile.parent_tile = parentTile
            }
            
            var users = Set<MOUser>()
            for accountJSON in accountsJSON {
                let user: MOUser = try store.newOrExisting(inContext: context, withJSON: accountJSON, withParser: parser)
                users.insert(user)
            }
            tile.users = users as NSSet?
            
            try context.save()
        })
        
    }
    
}
