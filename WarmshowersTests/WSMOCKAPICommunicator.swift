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
    var getImageForURLCalled = false
    
    func getTokenAndNotify(_ requester: WSAPIResponseDelegate) {
        getTokenCalled = true
    }
    
    func login(_ username: String, password: String, andNotify: WSAPIResponseDelegate) {
        loginCalled = true
    }
    
    func logoutAndNotify(_ requester: WSAPIResponseDelegate) {
        logoutCalled = true
    }
    
    func searchByLocation(_ regionLimits: [String: String], andNotify requester: WSAPIResponseDelegate) {
        searchByLocationCalled = true
    }
    
    func searchByKeyword(_ keyword: String, offset: Int, andNotify requester: WSAPIResponseDelegate) {
        searchByKeywordCalled = true
    }
    
    func getUserInfo(_ uid: Int, andNotify requester: WSAPIResponseDelegate) {
        getUserInfoCalled = true
    }
    
    func getUserFeedback(_ uid: Int, andNotify requester: WSAPIResponseDelegate) {
        getUserFeedbackCalled = true
    }
    
    func createFeedback(_ feedback: WSRecommendation, andNotify: WSAPIResponseDelegate) {
        createFeedbackCalled = true
    }

    func sendNewMessageToRecipients(_ recipients: [CDWSUser], withSubject subject: String, andMessageBody body: String, thenNotify requester: WSAPIResponseDelegate) {
        sendNewMessageToRecipientsCalled = true
    }
    
    func replyToMessageOnThread(_ threadID: Int, withMessageBody body: String, thenNotify requester: WSAPIResponseDelegate) {
        replyToMessageOnThreadCalled = true
    }
    
    func getUnreadMessageCountAndNotify(_ requester: WSAPIResponseDelegate) {
        getUnreadMessageCountAndNotifyCalled = true
    }
    
    func getAllMessageThreadsAndNotify(_ requester: WSAPIResponseDelegate) {
        getAllMessageThreadsAndNotifyCalled = true
    }
    
    func getMessagesOnThread(_ threadID: Int, andNotify requester: WSAPIResponseDelegate) {
        getMessagesOnThreadCalled = true
    }
    
    func markMessage(_ threadID: Int, andNotify requester: WSAPIResponseDelegate) {
        markMessageCalled = true
    }
    
    func getImageAtURL(_ imageURL: String, andNotify requester: WSAPIResponseDelegate) {
        getImageForURLCalled = true
    }
}
