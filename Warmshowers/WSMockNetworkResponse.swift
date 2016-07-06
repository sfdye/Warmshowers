//
//  WSMockNetworkResponse.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 16/05/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

class WSMockNetworkResponse {
    
    class func networkResponseFromFixture() -> (Data?, URLResponse?, NSError?) {
        
//        // Load the data from the JSON fixture
//        guard
//            let path = NSBundle.mainBundle().pathForResource(fixture.filePath, ofType: "json"),
//            let fixtureData = NSData(contentsOfFile: path)
//            else {
//                assertionFailure("Fixture not found at \(fixture.filePath).")
//        }
//        
//        let fixtureJSON: NSDictionary?
//        do {
//            fixtureJSON = try NSJSONSerialization.JSONObjectWithData(fixtureData, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary
//        } catch {
//            assertionFailure("Fixture \(fixture.filePath) failed parsing.")
//        }
//        
//        guard
//            let responseBody = fixtureJSON?.objectForKey("data"),
//            let responseHeader = fixtureJSON?.objectForKey("response")
//            else {
//                assertionFailure("Fixture \(fixture.filePath) failed parsing.")
//        }
        
        // Convert the data to NSData and NSURLResponse
        
        
//        let headerFields: [String: String] = ["Content-Type" : fixture.endPoint.accept.rawValue]
//        NSHTTPURLResponse(URL: <#T##NSURL#>, statusCode: <#T##Int#>, HTTPVersion: "HTTP/1.1", headerFields: headerFields)
//        
//        let data = NSJSONSerialization.dataWithJSONObject(responseJSON, options: .PrettyPrinted)
        
        return (nil, nil, nil)
    }
}
