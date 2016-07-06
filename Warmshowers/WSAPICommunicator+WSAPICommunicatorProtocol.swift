//
//  WSAPICommunicator+WSAPICommunicatorProtocol.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 9/05/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

extension WSAPICommunicator : WSAPICommunicatorProtocol {
    
    func getTokenAndNotify(_ requester: WSAPIResponseDelegate) {
        contactEndPoint(.token, thenNotify: requester)
    }
    
    func login(_ username: String, password: String, andNotify requester: WSAPIResponseDelegate) {
        
        let params = ["username" : username, "password" : password]
        
        contactEndPoint(.login, withParameters: params, thenNotify: requester)
    }
    
    func logoutAndNotify(_ requester: WSAPIResponseDelegate) {
        contactEndPoint(.logout, thenNotify: requester)
    }
    
    func searchByLocation(_ regionLimits: [String: String], andNotify requester: WSAPIResponseDelegate) {
        
        var params = regionLimits
        params["limit"] = String(MapSearchLimit)
        
        contactEndPoint(.searchByLocation, withParameters: params, thenNotify: requester)
    }
    
    func searchByKeyword(_ keyword: String, offset: Int, andNotify requester: WSAPIResponseDelegate) {
        
        var params = [String: String]()
        params["keyword"] = keyword ?? " "
        params["offset"] = String(offset)
        params["limit"] = String(KeywordSearchLimit)
        
        contactEndPoint(.searchByKeyword, withParameters: params, thenNotify: requester)
    }
    
    func getUserInfo(_ uid: Int, andNotify requester: WSAPIResponseDelegate) {
        
    }
    
    func getUserFeedback(_ uid: Int, andNotify requester: WSAPIResponseDelegate) {
        
    }
    
    func createFeedback(_ feedback: WSRecommendation, andNotify requester: WSAPIResponseDelegate) {
        
        var params = [String: String]()
        params["node[type]"] = "trust_referral"
        params["node[field_member_i_trust][0][uid][uid]"] = feedback.recommendedUserName
        params["node[field_rating][value]"] = feedback.rating.rawValue
        params["node[body]"] = feedback.body
        params["node[field_guest_or_host][value]"] = feedback.type.rawValue
        params["node[field_hosting_date][0][value][year]"] = String(feedback.year)
        params["node[field_hosting_date][0][value][month]"] = String(feedback.month)
        
        contactEndPoint(.createFeedback, withParameters: params, thenNotify: requester)
    }
    
    func sendNewMessageToRecipients(_ recipients: [CDWSUser], withSubject subject: String, andMessageBody body: String, thenNotify requester: WSAPIResponseDelegate) {
        
    }
    
    func replyToMessageOnThread(_ threadID: Int, withMessageBody body: String, thenNotify requester: WSAPIResponseDelegate) {
        
    }
    
    func getUnreadMessageCountAndNotify(_ requester: WSAPIResponseDelegate) {
    
    }
    
    func getAllMessageThreadsAndNotify(_ requester: WSAPIResponseDelegate) {
        
    }
    
    func getMessagesOnThread(_ threadID: Int, andNotify requester: WSAPIResponseDelegate) {
        
    }
    
    func markMessage(_ threadID: Int, andNotify requester: WSAPIResponseDelegate) {
        
    }
    
    func getImageAtURL(_ imageURL: String, andNotify requester: WSAPIResponseDelegate) {
        downloadImageAtURL(imageURL, thenNotify: requester)
    }
}
