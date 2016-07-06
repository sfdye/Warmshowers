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
    
    var type: WSAPIEndPoint { return .searchByLocation }
    
    var path: String { return "/services/rest/hosts/by_location" }
    
    var method: HttpMethod { return .Post }
    
    func request(_ request: WSAPIRequest, didRecievedResponseWithJSON json: AnyObject) throws -> AnyObject? {
        
        guard let accounts = json["accounts"] as? NSArray else {
            throw WSAPIEndPointError.parsingError(endPoint: path, key: "accounts")
        }
        
        var userLocations = [WSUserLocation]()
        for account in accounts {
            if let userLocation = WSUserLocation(json: account) {
                userLocations.append(userLocation)
            } else {
                throw WSAPIEndPointError.parsingError(endPoint: path, key: nil)
            }
        }
        
        return userLocations
    }
}
