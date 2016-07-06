//
//  WSAPIEndPoint.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 22/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

enum WSAPIEndPoint {
    case token
    case login
    case logout
    case searchByLocation
    case searchByKeyword
    case userInfo
    case userFeedback
    case createFeedback
    case newMessage
    case replyToMessage
    case unreadMessageCount
    case getAllMessageThreads
    case getMessageThread
    case markMessage
    case imageResource
    
    /** Returns the shared instance of the end point */
    var sharedEndPoint: WSAPIEndPointProtocol {
        switch self {
        case .token:
            return WSTokenEndPoint.sharedEndPoint
        case .login:
            return WSLoginEndPoint.sharedEndPoint
        case .logout:
            return WSLogoutEndPoint.sharedEndPoint
        case .searchByLocation:
            return WSSearchByLocationEndPoint.sharedEndPoint
        case .searchByKeyword:
            return WSSearchByKeywordEndPoint.sharedEndPoint
        case .userInfo:
            return WSUserInfoEndPoint.sharedEndPoint
        case .userFeedback:
            return WSUserFeedbackEndPoint.sharedEndPoint
        case .createFeedback:
            return WSCreateFeedbackEndPoint.sharedEndPoint
        case .newMessage:
            return WSNewMessageEndPoint.sharedEndPoint
        case .replyToMessage:
            return WSReplyToMessageEndPoint.sharedEndPoint
        case .unreadMessageCount:
            return WSUnreadMessageCountEndPoint.sharedEndPoint
        case .getAllMessageThreads:
            return WSGetAllMessageThreadsEndPoint.sharedEndPoint
        case .getMessageThread:
            return WSGetMessageThreadEndPoint.sharedEndPoint
        case .markMessage:
            return WSMarkMessageEndPoint.sharedEndPoint
        case .imageResource:
            assertionFailure("Resources can not be requested from a shared end point object. Create an instance of WSResourceURL instead.")
            return WSImageResourceURL(url: "")
        }
    }
}
