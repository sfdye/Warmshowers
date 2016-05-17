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
        case MissingPassword = "/JSON/401_MissingPasswordArgument.json"
    }
    
    extension WSLoginEndPoint {
        
        func generateMockResponseForURLRequest(urlRequest: NSMutableURLRequest) -> (NSData?, NSURLResponse?, NSError?) {
            let (data, response, error) = WSMockNetworkResponse.networkResponseFromFixture()
            return (data, response, error)
        }
    }
#endif
