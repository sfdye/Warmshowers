//
//  WSAPICommunicator+WSAPICommunicatorProtocol.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 9/05/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

extension WSAPICommunicator {
    
    func createFeedback(_ feedback: WSRecommendation, andNotify requester: WSAPIResponseDelegate) {
        
        var params = [String: String]()
        params["node[type]"] = "trust_referral"
        params["node[field_member_i_trust][0][uid][uid]"] = feedback.recommendedUserName
        params["node[field_rating][value]"] = feedback.rating.rawValue
        params["node[body]"] = feedback.body
        params["node[field_guest_or_host][value]"] = feedback.type.rawValue
        params["node[field_hosting_date][0][value][year]"] = String(feedback.year)
        params["node[field_hosting_date][0][value][month]"] = String(feedback.month)
        
        contact(endPoint: .CreateFeedback, withPathParameters: params, thenNotify: requester)
    }
    
    func sendNewMessageToRecipients(_ recipients: [WSMOUser], withSubject subject: String, andMessageBody body: String, thenNotify requester: WSAPIResponseDelegate) {
        
    }
    
    func replyToMessageOnThread(_ threadID: Int, withMessageBody body: String, thenNotify requester: WSAPIResponseDelegate) {
        
    }
    
}
