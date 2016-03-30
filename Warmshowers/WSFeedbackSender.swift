//
//  WSFeedbackSender.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 11/02/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

class WSFeedbackSender : WSRequestWithCSRFToken, WSRequestDelegate {
    
    var feedback: WSRecommendation!
    var userName: String!
    
    init(feedback: WSRecommendation, userName: String, success: (() -> Void)?, failure: ((error: NSError) -> Void)?) {
        super.init(success: success, failure: failure)
        requestDelegate = self
        self.feedback = feedback
        self.userName = userName
    }
    
    func requestForDownload() throws -> NSURLRequest {
        
        let service = WSRestfulService(type: .CreateFeedback)!
        
        var params = [String: String]()
        params["node[type]"] = "trust_referral"
        params["node[field_member_i_trust][0][uid][uid]"] = userName
        params["node[field_rating][value]"] = feedback.rating.rawValue
        params["node[body]"] = feedback.body
        params["node[field_guest_or_host][value]"] = feedback.recommendationFor.rawValue
        params["node[field_hosting_date][0][value][year]"] = String(feedback.year)
        params["node[field_hosting_date][0][value][month]"] = String(feedback.month)
        
        do {
            let request = try WSRequest.requestWithService(service, params: params, token: token)
            return request
        }
    }
    
    func doWithData(data: NSData) {
        
        // Check for success in response
        
    }
    
    // Starts the message sending process
    //
    func send() {
        tokenGetter.start()
    }
    
}
