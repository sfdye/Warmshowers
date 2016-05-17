//
//  WSAPIEndPoint.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 22/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

enum WSAPIEndPoint {
    case Token
    case Login
    case Logout
    case SearchByLocation
    case SearchByKeyword
    case UserInfo
    case UserFeedback
    case CreateFeedback
    case NewMessage
    case ReplyToMessage
    case UnreadMessageCount
    case GetAllMessageThreads
    case GetMessageThread
    case MarkMessage
    case ImageResource
    
    /** Returns the shared instance of the end point */
    var sharedEndPoint: WSAPIEndPointProtocol {
        switch self {
        case .Token:
            return WSTokenEndPoint.sharedEndPoint
        case .Login:
            return WSLoginEndPoint.sharedEndPoint
        case .Logout:
            return WSLogoutEndPoint.sharedEndPoint
        case .SearchByLocation:
            return WSSearchByLocationEndPoint.sharedEndPoint
        case .SearchByKeyword:
            return WSSearchByKeywordEndPoint.sharedEndPoint
        case .UserInfo:
            return WSUserInfoEndPoint.sharedEndPoint
        case .UserFeedback:
            return WSUserFeedbackEndPoint.sharedEndPoint
        case .CreateFeedback:
            return WSCreateFeedbackEndPoint.sharedEndPoint
        case .NewMessage:
            return WSNewMessageEndPoint.sharedEndPoint
        case .ReplyToMessage:
            return WSReplyToMessageEndPoint.sharedEndPoint
        case .UnreadMessageCount:
            return WSUnreadMessageCountEndPoint.sharedEndPoint
        case .GetAllMessageThreads:
            return WSGetAllMessageThreadsEndPoint.sharedEndPoint
        case .GetMessageThread:
            return WSGetMessageThreadEndPoint.sharedEndPoint
        case .MarkMessage:
            return WSMarkMessageEndPoint.sharedEndPoint
        case .ImageResource:
            assertionFailure("Resources can not be requested from a shared end point object. Create an instance of WSResourceURL instead.")
            return WSImageResourceURL(url: "")
        }
    }
}