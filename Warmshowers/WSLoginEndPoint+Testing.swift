//
//  WSLoginEndPoint+Testing.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 27/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

#if TEST
    enum WSLoginEndPointTestingMode : String {
        case Success = "/JSON/Login/200_UserObject.json"
        case MissingPassword = "401_MissingPasswordArgument.json"
    }
    
    extension WSLoginEndPoint {
        
//        var mode: WSLoginEndPointTestingMode = .Success
        
        func generateMockResponseForURLRequest(urlRequest: NSMutableURLRequest) -> (NSData?, NSURLResponse?, NSError?) {
            
//            let (data, response, error) = generateMockResponseWithJSON(json: "", andStatusCode: 200)

//            return (data, response, nil)
            return (nil, nil, nil)
        }
        
    }
#endif
