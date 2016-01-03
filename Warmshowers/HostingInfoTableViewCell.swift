//
//  HostingInfoTableViewCell.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 28/12/15.
//  Copyright © 2015 Rajan Fernandez. All rights reserved.
//

import UIKit

class HostingInfoTableViewCell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var infoLabel: UILabel!
    
    var title: String? {
        get {
            return titleLabel.text
        }
        set(newTitle) {
            guard newTitle != nil else {
                self.titleLabel.text = nil
                return
            }
            self.titleLabel.text = newTitle!
        }
    }
    
    var info: String? {
        get {
            return infoLabel.text
        }
        set(newInfo) {
            guard newInfo != nil else {
                self.infoLabel.text = nil
                return
            }
            self.infoLabel.text = newInfo!
        }
    }

}
