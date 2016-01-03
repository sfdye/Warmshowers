//
//  HostOfferTableViewCell.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 28/12/15.
//  Copyright © 2015 Rajan Fernandez. All rights reserved.
//

import UIKit

class HostOfferTableViewCell: UITableViewCell {
    
    @IBOutlet var offerLabel: UILabel!
    
    var offer: String? {
        get {
            return offerLabel.text
        }
        set(newOffer) {
            guard newOffer != nil else {
                self.offerLabel.text = nil
                return
            }
            self.offerLabel.text = "\u{2022} " + newOffer!
        }
    }
    
}
