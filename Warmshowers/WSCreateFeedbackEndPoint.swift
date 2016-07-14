//
//  WSCreateFeedbackEndPoint.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 22/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

class WSCreateFeedbackEndPoint : WSAPIEndPointProtocol {
    
    var type: WSAPIEndPoint = .CreateFeedback
    
    var httpMethod: HttpMethod = .Post
    
    func urlWithHostURL(hostURL: NSURL, andParameters parameters: AnyObject?) throws -> NSURL {
        return hostURL.URLByAppendingPathComponent("/services/rest/node")
    }
    
    func HTTPBodyWithData(data: AnyObject?) throws -> String {
        guard let recommendation = data as? WSRecommendation else { throw WSAPIEndPointError.InvalidOutboundData }
        var params = [String: String]()
        params["node[type]"] = "trust_referral"
        params["node[field_member_i_trust][0][uid][uid]"] = recommendation.recommendedUserName ?? ""
        params["node[field_rating][value]"] = recommendation.rating.rawValue
        params["node[body]"] = recommendation.body ?? ""
        params["node[field_guest_or_host][value]"] = recommendation.type.rawValue
        params["node[field_hosting_date][0][value][year]"] = String(recommendation.year)
        params["node[field_hosting_date][0][value][month]"] = String(recommendation.month)
        return HttpBody.bodyStringWithParameters(params)
    }
    
    func request(request: WSAPIRequest, didRecievedResponseWithJSON json: AnyObject) throws -> AnyObject? {
        // No need for response data.
        return nil
    }

}