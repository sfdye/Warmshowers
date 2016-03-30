//
//  WSUserLocation+WSLazyImageObject.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 16/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

extension WSUserLocation : WSLazyImage {
    
    var lazyImageURL: String? { return thumbnailImageURL }
    var lazyImage: UIImage? {
        get {
            return thumbnailImage
        }
        set(newImage) {
            thumbnailImage = newImage
        }
    }
    
}

