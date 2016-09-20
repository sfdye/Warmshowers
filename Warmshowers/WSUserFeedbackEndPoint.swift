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
    
    func url(withHostURL hostURL: URL, andParameters parameters: Any?) throws -> URL {
        guard let uidString = parameters as? NSString else { throw WSAPIEndPointError.invalidPathParameters }
        return hostURL.appendingPathComponent("/user/\(uidString)/json_recommendations")
    }
    
    func request(_ request: WSAPIRequest, didRecieveResponseWithJSON json: Any) throws -> Any? {
        
        guard let json = json as? [String: Any] else {
            throw WSAPIEndPointError.parsingError(endPoint: name, key: nil)
        }
        
        guard let recommendations = json["recommendations"] as? [AnyObject] else {
            throw WSAPIEndPointError.parsingError(endPoint: name, key: "recommendations")
        }
        
        var feedback = [WSRecommendation]()
        for recommendation in recommendations {
            
            guard
                let recommendationJSON = recommendation["recommendation"],
                let wsrecommendation = WSRecommendation(json: recommendationJSON! as AnyObject)
                else {
                    throw WSAPIEndPointError.parsingError(endPoint: name, key: "recommendation")
            }

            feedback.append(wsrecommendation)
        }
        return feedback as AnyObject?
    }
}
