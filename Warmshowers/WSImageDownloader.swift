//
//  WSImageDownloader.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 15/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

class WSImageDownloader : NSObject {
    
    var object: WSLazyImageDataSource?
    var task = NSURLSessionDataTask()
    var placeHolderImage: UIImage?
    var completionHandler: (() -> Void)?
    
    override init() {
        super.init()
    }
    
    // Downloads the objects image an stores in in the object object
    //
    func startDownload() {
        
        guard var object = object where object.lazyImageURL != nil else {
            return
        }
        
        guard let url = NSURL(string: object.lazyImageURL!) else {
            return
        }
        
        let session = NSURLSession.init(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        
        task = session.dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in

            // No data. Use the placeholder image instead
            guard let data = data else {
                object.lazyImage = self.placeHolderImage
                self.completionHandler?()
                return
            }
            
            // Set the image
            if let image = UIImage(data: data) {
                object.lazyImage = image
            } else {
                object.lazyImage = self.placeHolderImage
            }
            
            self.completionHandler?()
        })
        
        task.resume()
    }

    // Cancels the download task
    //
    func cancelDownload() {
        task.cancel()
    }
}
