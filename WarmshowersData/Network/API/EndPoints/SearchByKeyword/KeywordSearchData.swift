//
//  KeywordSearchParameters.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 9/07/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

class KeywordSearchData {
    
    var keyword: String
    var offset: Int
    var limit: Int
    
    var asParameters: [String: String] {
        var params = [String: String]()
        params["keyword"] = keyword
        params["offset"] = String(offset)
        params["limit"] = String(limit)
        return params
    }
    
    init(keyword: String, offset: Int = 0, limit: Int = 50) {
        self.keyword = keyword
        self.offset = offset
        self.limit = limit
    }
    
}
