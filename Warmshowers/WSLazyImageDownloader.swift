//
//  WSLazyImageDownloader.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 15/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

class WSLazyImageDownloader : WSRequester, WSRequestDelegate {
    
    var object: WSLazyImage!
    var placeholderImage: UIImage?
    
    init(lazyImageObject: WSLazyImage, success: (() -> Void)?, failure: ((error: NSError) -> Void)?) {
        super.init(success: success, failure: failure)
        requestDelegate = self
        self.object = lazyImageObject
    }
    
    func requestForDownload() throws -> NSURLRequest {
        
        guard let object = object where object.lazyImageURL != nil else {
            throw WSLazyImageError.NoImageURL
        }
        
        guard let url = NSURL(string: object.lazyImageURL!) else {
            throw WSLazyImageError.CouldNotFormURL
        }
        
        let request = NSURLRequest(URL: url)
        return request
    }
    
    func doWithData(data: NSData) {
        // Set the image
        if let image = UIImage(data: data) {
            object?.lazyImage = image
        } else {
            object?.lazyImage = self.placeholderImage
        }
    }
    
    override func nilDataAction() {
        object?.lazyImage = self.placeholderImage
    }
    
}
