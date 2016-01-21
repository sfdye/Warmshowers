//
//  WSLazyImageDownloader.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 15/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

class WSLazyImageDownloader : WSDataDownloader {
    
    var object: WSLazyImage?
    var placeHolderImage: UIImage?
    
    override init() {
        super.init()
    }
    
    // Downloads the objects image an stores in in the object object
    //
    func start() {
        
        guard var object = object where object.lazyImageURL != nil else {
            failure?()
            return
        }
        
        guard let url = NSURL(string: object.lazyImageURL!) else {
            failure?()
            return
        }
        
        task = session.dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
            
            // No data. Use the placeholder image instead
            guard let data = data else {
                object.lazyImage = self.placeHolderImage
                self.failure?()
                return
            }

            // Set the image
            if let image = UIImage(data: data) {
                object.lazyImage = image
            } else {
                object.lazyImage = self.placeHolderImage
            }
            
            self.success?()
        })

        task.resume()
    }
    
}
