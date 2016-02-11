//
//  WSRestService.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 24/12/15.
//  Copyright © 2015 Rajan Fernandez. All rights reserved.
//

import Foundation

enum WSRestfulServiceType {
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
}

enum HttpMethod {
    case Get
    case Post
}

struct WSRestfulService {
    
    // MARK: Instance properties
    
    var type: WSRestfulServiceType
    
    var url: NSURL
    
    var method: HttpMethod {
        switch type {
        case .Token, .UserInfo, .UserFeedback:
            return HttpMethod.Get
        default:
            return HttpMethod.Post
        }
    }
    
    var methodAsString: String {
        switch method {
        case .Get:
            return "GET"
        case .Post:
            return "POST"
        }
    }
    
    // MARK: Initialisers
    
    init?(type: WSRestfulServiceType, uid: Int? = nil) {
        
        self.type = type
        
        do {
            self.url = try WSURL.forServiceType(type, uid: uid)
        } catch {
            return nil
        }
    }

}