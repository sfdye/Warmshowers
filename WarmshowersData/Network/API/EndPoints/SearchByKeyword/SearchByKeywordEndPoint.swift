//
//  SearchByKeywordEndPoint.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 30/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

class SearchByKeywordEndPoint : APIEndPointProtocol {
    
    var type: APIEndPoint = .searchByKeyword
    
    func url(withHostURL hostURL: URL, andParameters parameters: Any?) throws -> URL {
        return hostURL.appendingPathComponent("/services/rest/hosts/by_keyword")
    }
    
    func httpBody(fromData data: Any?, forMethod method: HTTP.Method, withEncoder encoder: APIRequestDataEncoder) throws -> Data? {
        
        guard data is KeywordSearchData else {
            throw APIEndPointError.invalidOutboundData(endPoint: name, errorDescription: "The \(name) end point requires a KeywordSearchData object in the request data.")
        }
        
        let params = (data as! KeywordSearchData).asParameters
        let body = try encoder.body(fromParameters: params)
        return body
    }
    
    func request(_ request: APIRequest, didRecieveResponseWithJSON json: Any, parser: JSONParser) throws -> Any? {
        
        guard let json = json as? [String: Any] else {
            throw APIEndPointError.parsingError(endPoint: name, key: nil)
        }
        
        guard let accounts = json["accounts"] as? NSDictionary else {
            throw APIEndPointError.parsingError(endPoint: name, key: "accounts")
        }
        
        var hosts = [UserLocation]()
        for (_, account) in accounts {
            if let user = UserLocation(json: account as AnyObject) {
                hosts.append(user)
            }
        }
        
        return hosts as AnyObject?
    }
}
