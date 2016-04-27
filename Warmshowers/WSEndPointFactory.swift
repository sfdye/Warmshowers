//
//  WSEndPointFactory.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 22/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

/**
 Factory class for choosing an API service.
 */
class WSAPIEndPointFactory {
    static func endPointWithEndPoint(endPoint: WSAPIEndPoint, andUID uid: Int? = nil) -> WSAPIEndPointProtocol {
        switch endPoint {
        case .Token:
            return WSTokenEndPoint.sharedEndPoint
        case .Login:
            return WSLoginEndPoint.sharedEndPoint
        case .Logout:
            return WSCreateFeedbackEndPoint.sharedEndPoint // NEEDS CHANGE
        case .SearchByLocation:
            return WSCreateFeedbackEndPoint.sharedEndPoint // NEEDS CHANGE
        case .SearchByKeyword:
            return WSCreateFeedbackEndPoint.sharedEndPoint // NEEDS CHANGE
        case .UserInfo:
            return WSCreateFeedbackEndPoint.sharedEndPoint // NEEDS CHANGE
        case .UserFeedback:
            return WSCreateFeedbackEndPoint.sharedEndPoint // NEEDS CHANGE
        case .CreateFeedback:
            return WSCreateFeedbackEndPoint.sharedEndPoint
        case .NewMessage:
            return WSCreateFeedbackEndPoint.sharedEndPoint // NEEDS CHANGE
        case .ReplyToMessage:
            return WSCreateFeedbackEndPoint.sharedEndPoint // NEEDS CHANGE
        case .UnreadMessageCount:
            return WSCreateFeedbackEndPoint.sharedEndPoint // NEEDS CHANGE
        case .GetAllMessageThreads:
            return WSCreateFeedbackEndPoint.sharedEndPoint // NEEDS CHANGE
        case .GetMessageThread:
            return WSCreateFeedbackEndPoint.sharedEndPoint // NEEDS CHANGE
        case .MarkMessage:
            return WSCreateFeedbackEndPoint.sharedEndPoint // NEEDS CHANGE
        }
    }
}