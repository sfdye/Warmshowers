//
//  WSAPICommunicatorProtocol.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 21/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

protocol WSAPICommunicatorProtocol {
    func getTokenAndNotify(requester: WSAPIResponseDelegate)
    func login(username: String, password: String, andNotify requester: WSAPIResponseDelegate)
    func logoutAndNotify(requester: WSAPIResponseDelegate)
    func searchByLocation(mapTile: WSMapTile, andNotify requester: WSAPIResponseDelegate)
    func searchByKeyword(keyword: String, offset: Int, andNotify requester: WSAPIResponseDelegate)
    func getUserInfo(uid: Int, andNotify requester: WSAPIResponseDelegate)
    func getUserFeedback(uid: Int, andNotify requester: WSAPIResponseDelegate)
    func createFeedback(feedback: WSRecommendation, andNotify requester: WSAPIResponseDelegate)
    func sendNewMessageToRecipients(recipients: [CDWSUser], withSubject subject: String, andMessageBody body: String, thenNotify requester: WSAPIResponseDelegate)
    func replyToMessageOnThread(threadID: Int, withMessageBody body: String, thenNotify requester: WSAPIResponseDelegate)
    func getUnreadMessageCountAndNotify(requester: WSAPIResponseDelegate)
    func getAllMessageThreadsAndNotify(requester: WSAPIResponseDelegate)
    func getMessagesOnThread(threadID: Int, andNotify requester: WSAPIResponseDelegate)
    func markMessage(threadID: Int, andNotify requester: WSAPIResponseDelegate)
    func getImageAtURL(imageURL: String, andNotify requester: WSAPIResponseDelegate)
}