//
//  WSMOCKAPICommunicator.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 21/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation
@testable import Warmshowers

class WSMOCKAPICommunicator : WSAPICommunicatorProtocol {
    
    var getTokenCalled = false
    var loginCalled = false
    var logoutCalled = false
    var searchByLocationCalled = false
    var searchByKeywordCalled = false
    var createFeedbackCalled = false
    var getUserInfoCalled = false
    var getUserFeedbackCalled = false
    var sendNewMessageToRecipientsCalled = false
    var replyToMessageOnThreadCalled = false
    var getUnreadMessageCountAndNotifyCalled = false
    var getAllMessageThreadsAndNotifyCalled = false
    var getMessagesOnThreadCalled = false
    var markMessageCalled = false
    
    func getTokenAndNotify(requester: WSAPIResponseDelegate) {
        getTokenCalled = true
    }
    
    func login(username: String, password: String, andNotify: WSAPIResponseDelegate) {
        loginCalled = true
    }
    
    func logoutAndNotify(requester: WSAPIResponseDelegate) {
        logoutCalled = true
    }
    
    func searchByLocation(regionLimits: [String: String], andNotify requester: WSAPIResponseDelegate) {
        searchByLocationCalled = true
    }
    
    func searchByKeyword(keyword: String, offset: Int, andNotify requester: WSAPIResponseDelegate) {
        searchByKeywordCalled = true
    }
    
    func getUserInfo(uid: Int, andNotify requester: WSAPIResponseDelegate) {
        getUserInfoCalled = true
    }
    
    func getUserFeedback(uid: Int, andNotify requester: WSAPIResponseDelegate) {
        getUserFeedbackCalled = true
    }
    
    func createFeedback(feedback: WSRecommendation, andNotify: WSAPIResponseDelegate) {
        createFeedbackCalled = true
    }

    func sendNewMessageToRecipients(recipients: [CDWSUser], withSubject subject: String, andMessageBody body: String, thenNotify requester: WSAPIResponseDelegate) {
        sendNewMessageToRecipientsCalled = true
    }
    
    func replyToMessageOnThread(threadID: Int, withMessageBody body: String, thenNotify requester: WSAPIResponseDelegate) {
        replyToMessageOnThreadCalled = true
    }
    
    func getUnreadMessageCountAndNotify(requester: WSAPIResponseDelegate) {
        getUnreadMessageCountAndNotifyCalled = true
    }
    
    func getAllMessageThreadsAndNotify(requester: WSAPIResponseDelegate) {
        getAllMessageThreadsAndNotifyCalled = true
    }
    
    func getMessagesOnThread(threadID: Int, andNotify requester: WSAPIResponseDelegate) {
        getMessagesOnThreadCalled = true
    }
    
    func markMessage(threadID: Int, andNotify requester: WSAPIResponseDelegate) {
        markMessageCalled = true
    }
}