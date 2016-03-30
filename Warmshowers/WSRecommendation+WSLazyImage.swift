//
//  WSRecommendation+WSLazyObject.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 16/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

extension WSRecommendation : WSLazyImage {
    
    var lazyImageURL: String? { return authorImageURL }
    var lazyImage: UIImage? {
        get {
            return authorImage
        }
        set(newImage) {
            authorImage = newImage
        }
    }
}