//
//  WSSearchByLocationEndPoint.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 9/05/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

class WSSearchByLocationEndPoint : WSAPIEndPointProtocol {
    
    static let sharedEndPoint = WSSearchByLocationEndPoint()
    
    var type: WSAPIEndPoint { return .SearchByLocation }
    
    var path: String { return "/services/rest/hosts/by_location" }
    
    var method: HttpMethod { return .Post }
    
    func request(request: WSAPIRequest, didRecievedResponseWithJSON json: AnyObject) throws -> AnyObject? {
        
        guard let accounts = json["accounts"] as? NSArray else {
            throw WSAPIEndPointError.ParsingError(endPoint: path, key: "accounts")
        }
        
//        WSStore.sharedStore.privateContext.performBlockAndWait {
//            
//            var tile: CDWSMapTile!
//            do {
//                //                tile = try WSStore.newOrExistingMapTileAtPosition(self.x!, y: self.y!, z: self.z!)
//            } catch let nserror as NSError {
//                self.error = nserror
//                return
//            }
//            
//            print("got \(accounts.count) accounts")
//            
//            // Parse the json and add the users to the map tile
//            for userLocationJSON in accounts {
//                do {
//                    //                    try WSStore.addUserToMapTile(tile, withLocationJSON:userLocationJSON)
//                } catch let nserror as NSError {
//                    self.error = nserror
//                    return
//                }
//            }
//            
//            // Mark the tile as updated
//            tile.setValue(NSDate(timeIntervalSinceNow: 0), forKey: "last_updated")
//            print(tile.last_updated)
//            do {
//                //                try store.savePrivateContext()
//                //                print("Successfully updated tile data")
//            } catch let nserror as NSError {
//                self.error = nserror
//                return
//            }
//        }
        
        return nil
    }
}