//
//  APICommunicator+URLSessionDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 9/01/17.
//  Copyright © 2017 Rajan Fernandez. All rights reserved.
//

import Foundation

extension APICommunicator: URLSessionDataDelegate {
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, willCacheResponse proposedResponse: CachedURLResponse, completionHandler: @escaping (CachedURLResponse?) -> Void) {
        
        
        // Set the maximum age of the cache to 24 hours.
        
        
        
        
//        NSCachedURLResponse *newCachedResponse = proposedResponse;
//        NSDictionary *newUserInfo;
//        newUserInfo = [NSDictionary dictionaryWithObject:[NSDate date]
//            forKey:@"Cached Date"];
//        if ([proposedResponse.response.URL.scheme isEqualToString:@"https"]) {
//            #if ALLOW_IN_MEMORY_CACHING
//                newCachedResponse = [[NSCachedURLResponse alloc]
//                    initWithResponse:proposedResponse.response
//                    data:proposedResponse.data
//                    userInfo:newUserInfo
//                    storagePolicy:NSURLCacheStorageAllowedInMemoryOnly];
//            #else // !ALLOW_IN_MEMORY_CACHING
//                newCachedResponse = nil;
//            #endif // ALLOW_IN_MEMORY_CACHING
//        } else {
//            newCachedResponse = [[NSCachedURLResponse alloc]
//                initWithResponse:[proposedResponse response]
//                data:[proposedResponse data]
//                userInfo:newUserInfo
//                storagePolicy:[proposedResponse storagePolicy]];
//        }
//        
//        completionHandler(newCachedResponse);
        
        completionHandler(proposedResponse)
    }
    
    
}
