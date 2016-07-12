//
//  WSAPIEndPoint.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 22/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

enum WSAPIEndPoint: String {
    case Token = "Token"
    case Login = "Login"
    case Logout = "Logout"
    case SearchByLocation = "SearchByLocation"
    case SearchByKeyword = "SearchByKeyword"
    case UserInfo = "UserInfo"
    case UserFeedback = "UserFeedback"
    case CreateFeedback = "CreateFeedback"
    case NewMessage = "NewMessage"
    case ReplyToMessage = "ReplyToMessage"
    case UnreadMessageCount = "UnreadMessageCount"
    case GetAllMessageThreads = "GetAllMessageThreads"
    case GetMessageThread = "GetMessageThread"
    case MarkThreadRead = "MarkThreadRead"
    case ImageResource = "ImageResource"
    
    /** Returns the name of the end point. */
    var name: String { return self.rawValue }
    
    /** Returns the class of the object that describes the end point. */
    var instance: WSAPIEndPointProtocol {
        switch self {
        case .Token:
            return WSTokenEndPoint()
        case .Login:
            return WSLoginEndPoint()
        case .Logout:
            return WSLogoutEndPoint()
        case .SearchByLocation:
            return WSSearchByLocationEndPoint()
        case .SearchByKeyword:
            return WSSearchByKeywordEndPoint()
        case .UserInfo:
            return WSUserEndPoint()
        case .UserFeedback:
            return WSUserFeedbackEndPoint()
        case .CreateFeedback:
            return WSCreateFeedbackEndPoint()
        case .NewMessage:
            return WSNewMessageEndPoint()
        case .ReplyToMessage:
            return WSReplyToMessageEndPoint()
        case .UnreadMessageCount:
            return WSUnreadMessageCountEndPoint()
        case .GetAllMessageThreads:
            return WSGetAllMessageThreadsEndPoint()
        case .GetMessageThread:
            return WSGetMessageThreadEndPoint()
        case .MarkThreadRead:
            return WSMarkThreadReadEndPoint()
        case .ImageResource:
            return WSImageResourceEndPoint()
        }
    }
    
}