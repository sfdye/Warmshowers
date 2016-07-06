//
//  WSAPICommunicatorProtocol.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 21/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

protocol WSAPICommunicatorProtocol {
    func getTokenAndNotify(_ requester: WSAPIResponseDelegate)
    func login(_ username: String, password: String, andNotify requester: WSAPIResponseDelegate)
    func logoutAndNotify(_ requester: WSAPIResponseDelegate)
    func searchByLocation(_ regionLimits: [String: String], andNotify requester: WSAPIResponseDelegate)
    func searchByKeyword(_ keyword: String, offset: Int, andNotify requester: WSAPIResponseDelegate)
    func getUserInfo(_ uid: Int, andNotify requester: WSAPIResponseDelegate)
    func getUserFeedback(_ uid: Int, andNotify requester: WSAPIResponseDelegate)
    func createFeedback(_ feedback: WSRecommendation, andNotify requester: WSAPIResponseDelegate)
    func sendNewMessageToRecipients(_ recipients: [CDWSUser], withSubject subject: String, andMessageBody body: String, thenNotify requester: WSAPIResponseDelegate)
    func replyToMessageOnThread(_ threadID: Int, withMessageBody body: String, thenNotify requester: WSAPIResponseDelegate)
    func getUnreadMessageCountAndNotify(_ requester: WSAPIResponseDelegate)
    func getAllMessageThreadsAndNotify(_ requester: WSAPIResponseDelegate)
    func getMessagesOnThread(_ threadID: Int, andNotify requester: WSAPIResponseDelegate)
    func markMessage(_ threadID: Int, andNotify requester: WSAPIResponseDelegate)
    func getImageAtURL(_ imageURL: String, andNotify requester: WSAPIResponseDelegate)
}
