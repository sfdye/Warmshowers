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
    
    func HTTPBodyWithData(data: AnyObject?) throws -> String {
        guard data is WSMapTile else { throw WSAPIEndPointError.InvalidOutboundData }
        var params = (data as! WSMapTile).regionLimits
        params["limit"] = String(MapSearchLimit)
        return HttpBody.bodyStringWithParameters(params)
    }
    
    func request(request: WSAPIRequest, didRecievedResponseWithJSON json: AnyObject) throws -> AnyObject? {
        
        guard let accounts = json["accounts"] as? NSArray else {
            throw WSAPIEndPointError.ParsingError(endPoint: name, key: "accounts")
        }
        
        var userLocations = [WSUserLocation]()
        for account in accounts {
            if let userLocation = WSUserLocation(json: account) {
                userLocations.append(userLocation)
            } else {
                throw WSAPIEndPointError.ParsingError(endPoint: name, key: nil)
            }
        }
        
        return userLocations
    }
    
}