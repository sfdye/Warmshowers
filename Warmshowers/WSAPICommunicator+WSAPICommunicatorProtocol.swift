//
//  WSAPICommunicator+WSAPICommunicatorProtocol.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 9/05/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

extension WSAPICommunicator : WSAPICommunicatorProtocol {
    
    func getTokenAndNotify(requester: WSAPIResponseDelegate) {
        contactEndPoint(.Token, thenNotify: requester)
    }
    
    func login(username: String, password: String, andNotify requester: WSAPIResponseDelegate) {
        
        let params = ["username" : username, "password" : password]
        
        contactEndPoint(.Login, withParameters: params, thenNotify: requester)
    }
    
    func logoutAndNotify(requester: WSAPIResponseDelegate) {
        contactEndPoint(.Logout, thenNotify: requester)
    }
    
    func searchByLocation(regionLimits: [String: String], andNotify requester: WSAPIResponseDelegate) {
        
        var params = regionLimits
        params["limit"] = String(MapSearchLimit)
        
        contactEndPoint(.SearchByLocation, withParameters: params, thenNotify: requester)
    }
    
    func searchByKeyword(keyword: String, offset: Int, andNotify requester: WSAPIResponseDelegate) {
        
        var params = [String: String]()
        params["keyword"] = keyword ?? " "
        params["offset"] = String(offset)
        params["limit"] = String(KeywordSearchLimit)
        
        contactEndPoint(.SearchByKeyword, withParameters: params, thenNotify: requester)
    }
    
    func getUserInfo(uid: Int, andNotify requester: WSAPIResponseDelegate) {
        
    }
    
    func getUserFeedback(uid: Int, andNotify requester: WSAPIResponseDelegate) {
        
    }
    
    func createFeedback(feedback: WSRecommendation, andNotify requester: WSAPIResponseDelegate) {
        
        var params = [String: String]()
        params["node[type]"] = "trust_referral"
        params["node[field_member_i_trust][0][uid][uid]"] = feedback.recommendedUserName
        params["node[field_rating][value]"] = feedback.rating.rawValue
        params["node[body]"] = feedback.body
        params["node[field_guest_or_host][value]"] = feedback.type.rawValue
        params["node[field_hosting_date][0][value][year]"] = String(feedback.year)
        params["node[field_hosting_date][0][value][month]"] = String(feedback.month)
        
        contactEndPoint(.CreateFeedback, withParameters: params, thenNotify: requester)
    }
    
    func sendNewMessageToRecipients(recipients: [CDWSUser], withSubject subject: String, andMessageBody body: String, thenNotify requester: WSAPIResponseDelegate) {
        
    }
    
    func replyToMessageOnThread(threadID: Int, withMessageBody body: String, thenNotify requester: WSAPIResponseDelegate) {
        
    }
    
    func getUnreadMessageCountAndNotify(requester: WSAPIResponseDelegate) {
    
    }
    
    func getAllMessageThreadsAndNotify(requester: WSAPIResponseDelegate) {
        
    }
    
    func getMessagesOnThread(threadID: Int, andNotify requester: WSAPIResponseDelegate) {
        
    }
    
    func markMessage(threadID: Int, andNotify requester: WSAPIResponseDelegate) {
        
    }
    
    func getImageAtURL(imageURL: String, andNotify requester: WSAPIResponseDelegate) {
        downloadImageAtURL(imageURL, thenNotify: requester)
    }
}