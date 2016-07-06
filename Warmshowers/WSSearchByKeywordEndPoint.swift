//
//  WSSearchByKeywordEndPoint.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 30/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

class WSSearchByKeywordEndPoint : WSAPIEndPointProtocol {
    
    static let sharedEndPoint = WSSearchByKeywordEndPoint()
    
    var type: WSAPIEndPoint { return .searchByKeyword }
    
    var path: String { return "/services/rest/hosts/by_keyword" }
    
    var method: HttpMethod { return .Post }
    
    func request(_ request: WSAPIRequest, didRecievedResponseWithJSON json: AnyObject) throws -> AnyObject? {
        
        guard let accounts = json["accounts"] as? NSDictionary else {
            throw WSAPIEndPointError.parsingError(endPoint: path, key: "accounts")
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
