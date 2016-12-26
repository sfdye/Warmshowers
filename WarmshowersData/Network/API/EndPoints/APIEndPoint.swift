//
//  APIEndPoint.swift
//  Powershop
//
//  Created by Rajan Fernandez on 22/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

/** 
 A enum that acts as a register for all the API enpoints. 
 
 To add an end point:
 1. Add a case for the end point to the enum.
 2. Add a case to the 'instance' function, that returns an instance of the class
 that describes the end point attributes.
 
 */
public enum APIEndPoint: String {
    case token = "Token"
    case login = "Login"
    case logout = "Logout"
    case searchByLocation = "SearchByLocation"
    case searchByKeyword = "SearchByKeyword"
    case user = "UserInfo"
    case feedback = "UserFeedback"
    case createFeedback = "CreateFeedback"
    case newMessage = "NewMessage"
    case replyToMessage = "ReplyToMessage"
    case unreadMessageCount = "UnreadMessageCount"
    case messageThreads = "MessageThreads"
    case messageThread = "MessageThread"
    case markThreadRead = "MarkThreadRead"
    case imageResource = "ImageResource"
    
    /** Returns the name of the end point. */
    var name: String { return self.rawValue }
    
    /** Returns the class of the object that describes the end point. */
    var instance: APIEndPointProtocol {
        switch self {
        case .token:
            return TokenEndPoint()
        case .login:
            return LoginEndPoint()
        case .logout:
            return LogoutEndPoint()
        case .searchByLocation:
            return SearchByLocationEndPoint()
        case .searchByKeyword:
            return SearchByKeywordEndPoint()
        case .user:
            return UserEndPoint()
        case .feedback:
            return UserFeedbackEndPoint()
        case .createFeedback:
            return CreateFeedbackEndPoint()
        case .newMessage:
            return NewMessageEndPoint()
        case .replyToMessage:
            return ReplyToMessageEndPoint()
        case .unreadMessageCount:
            return UnreadMessageCountEndPoint()
        case .messageThreads:
            return MessageThreadsEndPoint()
        case .messageThread:
            return MessageThreadEndPoint()
        case .markThreadRead:
            return MarkThreadReadEndPoint()
        case .imageResource:
            return ImageResourceEndPoint()
        }
    }
    
}
