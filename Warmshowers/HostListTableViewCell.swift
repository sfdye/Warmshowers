//
//  HostListTableViewCell.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 13/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

class HostListTableViewCell: UITableViewCell, WSLazyImageTableViewCell {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var profileImage: UIImageView!
    var uid: Int?
    
    var lazyImage: UIImage? {
        get {
            return profileImage.image
        }
        set(newImage) {
            profileImage.image = newImage
        }
    }
    
}
