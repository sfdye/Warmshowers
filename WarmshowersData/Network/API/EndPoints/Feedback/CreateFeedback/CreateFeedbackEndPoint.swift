//
//  CreateFeedbackEndPoint.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 22/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

struct CreateFeedbackEndPoint : APIEndPointProtocol {
    
    var type: APIEndPoint = .createFeedback
    
    func url(withHostURL hostURL: URL, andParameters parameters: Any?) throws -> URL {
        return hostURL.appendingPathComponent("/services/rest/node")
    }
    
    func httpBody(fromData data: Any?, forMethod method: HTTP.Method, withEncoder encoder: APIRequestDataEncoder) throws -> Data? {
        
        guard let recommendation = data as? Recommendation else {
            throw APIEndPointError.invalidOutboundData(endPoint: name, errorDescription: "The \(name) end point must received a recommendation in the request data.")
        }
        
        var params = [String: String]()
        params["node[type]"] = "trust_referral"
        params["node[field_member_i_trust][0][uid][uid]"] = recommendation.recommendedUserName ?? ""
        params["node[field_rating][value]"] = recommendation.rating.rawValue
        params["node[body]"] = recommendation.body ?? ""
        params["node[field_guest_or_host][value]"] = recommendation.type.rawValue
        params["node[field_hosting_date][0][value][year]"] = String(recommendation.year)
        params["node[field_hosting_date][0][value][month]"] = String(recommendation.month)
        let body = try encoder.body(fromParameters: params)
        return body
    }
    
     func request(_ request: APIRequest, didRecieveResponseWithJSON json: Any, parser: JSONParser) throws -> Any? {
        // No need for response data.
        return nil
    }

}
