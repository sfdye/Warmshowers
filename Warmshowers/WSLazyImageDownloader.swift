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
    
    init(lazyImageObject: WSLazyImage) {
        super.init()
        requestDelegate = self
        self.object = lazyImageObject
    }
    
    func requestForDownload() -> NSURLRequest? {
        
        guard let object = object where object.lazyImageURL != nil else {
            return nil
        }
        
        guard let url = NSURL(string: object.lazyImageURL!) else {
            return nil
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
