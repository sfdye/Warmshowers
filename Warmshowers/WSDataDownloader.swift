//
//  WSDataDownloader.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 16/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

class WSDataDownloader : NSObject {
    
    let session = NSURLSession.init(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
    
    var task = NSURLSessionDataTask()
    var completionHandler: (() -> Void)?
    
    override init() {
        super.init()
    }
    
    // Cancels the download task
    //
    func cancelDownload() {
        task.cancel()
    }
}
