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
    
    func url(withHostURL hostURL: URL, andParameters parameters: Any?) throws -> URL {
        return hostURL.appendingPathComponent("/services/rest/hosts/by_keyword")
    }
    
    func HTTPBodyParameters(withData data: Any?) throws -> [String: String] {
        guard data is WSKeywordSearchData else { throw WSAPIEndPointError.invalidOutboundData }
        return (data as! WSKeywordSearchData).asParameters
    }
    
    func request(_ request: WSAPIRequest, didRecieveResponseWithJSON json: Any) throws -> Any? {
        
        guard let json = json as? [String: Any] else {
            throw WSAPIEndPointError.parsingError(endPoint: name, key: nil)
        }
        
        guard let accounts = json["accounts"] as? NSDictionary else {
            throw WSAPIEndPointError.parsingError(endPoint: name, key: "accounts")
        }
        
        var hosts = [WSUserLocation]()
        for (_, account) in accounts {
            if let user = WSUserLocation(json: account as AnyObject) {
                hosts.append(user)
            }
        }
        
        return hosts as AnyObject?
    }
}
