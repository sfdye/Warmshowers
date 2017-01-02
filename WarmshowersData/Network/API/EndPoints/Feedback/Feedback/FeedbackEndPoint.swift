//
//  UserFeedbackEndPoint.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 9/05/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

struct UserFeedbackEndPoint: APIEndPointProtocol {
    
    var type: APIEndPoint = .feedback
    
    func url(withHostURL hostURL: URL, andParameters parameters: Any?) throws -> URL {
        
        guard let uid = parameters as? Int else {
            throw APIEndPointError.invalidPathParameters(endPoint: name, errorDescription: "The \(name) end point requires a user UID in the request path parameters.")
        }
        
        return hostURL.appendingPathComponent("/user/\(uid)/json_recommendations")
    }
    
     func request(_ request: APIRequest, didRecieveResponseWithJSON json: Any, parser: JSONParser) throws -> Any? {
        
        guard let json = json as? [String: Any] else {
            throw APIEndPointError.parsingError(endPoint: name, key: nil)
        }
        
        guard let recommendations = json["recommendations"] as? [Any] else {
            throw APIEndPointError.parsingError(endPoint: name, key: "recommendations")
        }
        
        var feedback = [Recommendation]()
        for recommendation in recommendations {
            
            guard
                let json = recommendation as? [String: Any],
                let recommendationJSON = json["recommendation"],
                let wsrecommendation = Recommendation(json: recommendationJSON)
                else {
                    throw APIEndPointError.parsingError(endPoint: name, key: "recommendation")
            }

            feedback.append(wsrecommendation)
        }
        return feedback
    }
}
