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
        
//        var feedback = [WSRecommendation]()
//        
//        // Parse the data
//        if let allRecommendations = json.valueForKey("recommendations") as? NSArray {
//            for recommendationObject in allRecommendations {
//                if let recommendationJSON = recommendationObject.valueForKey("recommendation") {
//                    if let recommendation = WSRecommendation(json: recommendationJSON) {
//                        feedback.append(recommendation)
//                    }
//                }
//            }
//        }
        
        return nil
    }
}