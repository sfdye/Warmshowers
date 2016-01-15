//
//  HostListTableViewCell+WSLazyImageTableViewCell.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 16/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

extension HostListTableViewCell : WSLazyImageTableViewCell {
    
    var lazyImage: UIImage? {
        get {
            return profileImage.image
        }
        set(newImage) {
            profileImage.image = newImage
        }
    }
    
}