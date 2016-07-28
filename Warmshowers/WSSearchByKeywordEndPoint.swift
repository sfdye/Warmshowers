//
//  WSSearchByKeywordEndPoint.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 30/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

class WSSearchByKeywordEndPoint : WSAPIEndPointProtocol {
    
    var type: WSAPIEndPoint = .SearchByKeyword
    
    var httpMethod: HttpMethod = .Post
    
    func urlWithHostURL(hostURL: NSURL, andParameters parameters: AnyObject?) throws -> NSURL {
        return hostURL.URLByAppendingPathComponent("/services/rest/hosts/by_keyword")
    }
    
    func HTTPBodyParametersWithData(data: AnyObject?) throws -> [String: String] {
        guard data is WSKeywordSearchData else { throw WSAPIEndPointError.InvalidOutboundData }
        return (data as! WSKeywordSearchData).asParameters
    }
    
    func request(request: WSAPIRequest, didRecieveResponseWithJSON json: AnyObject) throws -> AnyObject? {
        
        guard let accounts = json["accounts"] as? NSDictionary else {
            throw WSAPIEndPointError.ParsingError(endPoint: name, key: "accounts")
        }
        
        var hosts = [WSUserLocation]()
        for (_, account) in accounts {
            if let user = WSUserLocation(json: account) {
                hosts.append(user)
            }
        }
        
        return hosts
    }
}
