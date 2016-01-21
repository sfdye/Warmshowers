//
//  WSCSRFTokenGetter.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 21/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

class WSCSRFTokenGetter : WSDataDownloader {
    
    var token: String?
    
    func start() {
        
        let service = WSRestfulService.init(type: .token)
        let request = WSRequest.requestWithService(service!)
        
        task = session.dataTaskWithRequest(request!, completionHandler: { (data, response, error) -> Void in
            
            guard let data = data, let _ = response where error == nil else {
                print("Error getting X-CSRF token: Cancelling request")
                self.failure?()
                return
            }
            
            if let token = String.init(data: data, encoding: NSUTF8StringEncoding) {
                self.token = token
                self.success?()
            } else {
                print("Could not decode token data")
                self.failure?()
            }
        })
        task.resume()
    }
    
}