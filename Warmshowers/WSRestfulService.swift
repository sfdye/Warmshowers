//
//  WSRestService.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 24/12/15.
//  Copyright © 2015 Rajan Fernandez. All rights reserved.
//

import Foundation

enum WSRestfulServiceType {
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
}

enum HttpMethod {
    case get
    case post
}

struct WSRestfulService {
    
    // MARK: Instance properties
    
    var type: WSRestfulServiceType
    
    var url: NSURL
    
    var method: HttpMethod {
        switch type {
        case .token, .userInfo, .userFeedback:
            return HttpMethod.get
        default:
            return HttpMethod.post
        }
    }
    
    var methodAsString: String {
        switch method {
        case .get:
            return "GET"
        case .post:
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