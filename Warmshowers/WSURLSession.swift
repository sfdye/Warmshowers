//
//  WSURLSession.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 18/02/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit


class WSURLSession : NSObject, URLSessionDelegate {
    
    fileprivate let session = URLSession.init(configuration: URLSessionConfiguration.default)
    
    static let sharedSession = WSURLSession().session
    
    static func cancelAllDataTasksWithCompletionHandler(_ handler: (() -> Void)? = nil) {
        
        let session = WSURLSession.sharedSession
        
        session.getTasksWithCompletionHandler { (dataTasks: [URLSessionDataTask], uploadTasks: [URLSessionUploadTask], downloadTasks: [URLSessionDownloadTask]) -> Void in
            for task in dataTasks {
                task.cancel()
            }
            handler?()
        }
    }
}
