//
//  WSGetHostsForKeywordOperation.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 16/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

class WSGetHostsForKeywordOperation : NSOperation {
    
    var keyword: String!
    var success: ((hosts: [WSUserLocation]) -> Void)?
    var failure: (() -> Void)?
    
    init(keyword: String) {
        self.keyword = keyword
        super.init()
    }
    
    override func main() {
        
        // Get the new search results
        WSRequest.getHostDataForKeyword(keyword, offset: 0) { (data) -> Void in
            
            // About if the operation was cancelled
            guard self.cancelled == false else {
                return
            }
            
            // Update the tableView data source
            if let data = data {
                
                var hosts = [WSUserLocation]()
                
                // parse the json
                if let json = WSRequest.jsonDataToDictionary(data) {
                    if let accounts = json["accounts"] as? NSDictionary {
                        for (_, account) in accounts {
                            if let user = WSUserLocation(json: account) {
                                hosts.append(user)
                            }
                        }
                    }
                }
                
                if self.cancelled == false {
                    self.success?(hosts: hosts)
                }
            }
            self.failure?()
        }
    }
    
}