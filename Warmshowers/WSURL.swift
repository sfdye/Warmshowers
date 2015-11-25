//
//  WSURL.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 20/11/15.
//  Copyright © 2015 Rajan Fernandez. All rights reserved.
//

import Foundation

// Class to provide URLs for the various warmshowers.org RESTful services
class WSURL {
    static let sharedInstance = WSURL()
    
    // RESTful services URLs
    
    static let BASE = NSURL.init(string: "https://www.warmshowers.org")!
    
    // CSRF token
    class func TOKEN () -> NSURL {
        return BASE.URLByAppendingPathComponent("/services/session/token")
    }
    
    // login
    class func LOGIN () -> NSURL {
        return BASE.URLByAppendingPathComponent("/services/rest/user/login")
    }
    
    // logout
    class func LOGOUT () -> NSURL {
        return BASE.URLByAppendingPathComponent("/services/rest/user/logout")
    }
    
    // search for hosts by location
    class func LOCATION_SEARCH () -> NSURL {
        return BASE.URLByAppendingPathComponent("/services/rest/hosts/by_location")
    }
    
    // search for hosts by keyword
    class func KEYWORD_SEARCH () -> NSURL {
        return BASE.URLByAppendingPathComponent("/services/rest/hosts/by_keyword")
    }
    
    // get user info
    class func USER_INFO (uid: Int) -> NSURL {
        let path: String = String(format: "/services/rest/user/%i", arguments: [uid])
        return BASE.URLByAppendingPathComponent(path)
    }
    
    // get a users feedback
    class func USER_FEEDBACK (uid: Int) -> NSURL {
        let path: String = String(format: "/user/%i/json_recommendations", arguments: [uid])
        return BASE.URLByAppendingPathComponent(path)
    }
    
    // submit feedback for a user
    class func CREATE_FEEDBACK () -> NSURL {
        return BASE.URLByAppendingPathComponent("/services/rest/node")
    }
    
    // to send a message (but not sending replies to messages)
    class func SEND_MESSAGE () -> NSURL {
        return BASE.URLByAppendingPathComponent("/services/rest/message/send")
    }
    
    // to reply to a message
    class func REPLY_MESSAGE () -> NSURL {
        return BASE.URLByAppendingPathComponent("/services/rest/message/reply")
    }
    
    // to get a users unread message count
    class func UNREAD_MESSAGE_COUNT () -> NSURL {
        return BASE.URLByAppendingPathComponent("/services/rest/message/unreadCount")
    }
    
    // to get all messages for a user
    class func GET_ALL_MESSAGES () -> NSURL {
        return BASE.URLByAppendingPathComponent("/services/rest/message/get")
    }
    
    // to get a message thread
    class func GET_MESSAGE_THREAD () -> NSURL {
        return BASE.URLByAppendingPathComponent("/services/rest/message/getThread")
    }
    
    // to mark a message thread as read
    class func MARK_REPLY_AS_READ () -> NSURL {
        return BASE.URLByAppendingPathComponent("/services/rest/message/markThreadRead")
    }

}
