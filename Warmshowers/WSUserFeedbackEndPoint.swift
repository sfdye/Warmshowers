//
//  WSUserFeedbackEndPoint.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 9/05/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

class WSUserFeedbackEndPoint: WSAPIEndPointProtocol {
    
    var type: WSAPIEndPoint = .UserFeedback
    
    var httpMethod: HttpMethod = .Get
    
    func urlWithHostURL(hostURL: NSURL, andParameters parameters: AnyObject?) throws -> NSURL {
        guard let uidString = parameters as? NSString else { throw WSAPIEndPointError.InvalidPathParameters }
        return hostURL.URLByAppendingPathComponent("/user/\(uidString)/json_recommendations")
    }
    
    func request(request: WSAPIRequest, didRecievedResponseWithJSON json: AnyObject) throws -> AnyObject? {
        
        guard let recommendations = json["recommendations"] as? [AnyObject] else {
            throw WSAPIEndPointError.ParsingError(endPoint: name, key: "recommendations")
        }
        
        var feedback = [WSRecommendation]()
        for recommendation in recommendations {
            
            guard
                let recommendationJSON = recommendation["recommendation"],
                let wsrecommendation = WSRecommendation(json: recommendationJSON!)
                else {
                    throw WSAPIEndPointError.ParsingError(endPoint: name, key: "recommendation")
            }

            feedback.append(wsrecommendation)
        }
        return feedback
    }
}