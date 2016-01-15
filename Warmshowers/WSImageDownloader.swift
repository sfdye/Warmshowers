//
//  WSImageDownloader.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 15/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

class WSImageDownloader : NSObject {
    
    var user: WSUserLocation?
    var task = NSURLSessionDataTask()
    var completionHandler: (() -> Void)?
    
    override init() {
        super.init()
    }
    
    // Downloads the users thumbnail image an stores in in the user object
    //
    func startDownload() {
        
        guard let user = user where user.thumbnailImageURL != nil else {
            return
        }
        
        guard let url = NSURL(string: user.thumbnailImageURL!) else {
            return
        }
        
        let session = NSURLSession.init(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        
        task = session.dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
            
            guard let placeHolderImage = UIImage(named: "ThumbnailPlaceholder") else {
                self.completionHandler?()
                return
            }

            // No data. Leave the user image as nil to try again later.
            guard let data = data else {
                
                // Valid response, the user doesn't have a profile image.
                // Use the placeholder instead.
                if let response = response as? NSHTTPURLResponse {
                    if response.statusCode == 200 {
                        
                    }
                }
                // Else leave the image as nil so that the view tries to get the image again later.
                user.thumbnailImage = placeHolderImage
                self.completionHandler?()
                return
            }
            
            // Set the image
            if let image = UIImage(data: data) {
                user.thumbnailImage = image
            } else {
                print("setting placeholder")
                user.thumbnailImage = placeHolderImage
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
