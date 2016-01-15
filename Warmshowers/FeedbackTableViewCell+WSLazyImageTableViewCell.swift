//
//  FeedbackTableViewCell+WSLazyImageTableViewCell.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 16/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

extension FeedbackTableViewCell : WSLazyImageTableViewCell {
    
    var lazyImage: UIImage? {
        get {
            return authorImage.image
        }
        set(newImage) {
            authorImage.image = newImage
        }
    }
}