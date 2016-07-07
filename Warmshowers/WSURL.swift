//
//  WSURL.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 20/11/15.
//  Copyright © 2015 Rajan Fernandez. All rights reserved.
//

import UIKit

enum WSURLError : ErrorType {
    case InvalidInput
    case UnrecognisedWSServiceType
}

// Class to provide URLs for the various warmshowers.org RESTful services
class WSURL {
    
    // RESTful services URLs
    
    static let BASE = NSURL.init(string: "https://www.warmshowers.org")!

}
