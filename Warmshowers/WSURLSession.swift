//
//  WSURLSession.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 18/02/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation


class WSURLSession : NSObject, NSURLSessionDelegate {
    
    private let session = NSURLSession.init(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
    
    static let sharedSession = WSURLSession().session
    
    static func cancelAllDataTasksWithCompletionHandler(handler: (() -> Void)? = nil) {
        
        let session = WSURLSession.sharedSession
        
        session.getTasksWithCompletionHandler { (dataTasks: [NSURLSessionDataTask], uploadTasks: [NSURLSessionUploadTask], downloadTasks: [NSURLSessionDownloadTask]) -> Void in
            for task in dataTasks {
                task.cancel()
            }
            handler?()
        }
    }
}
