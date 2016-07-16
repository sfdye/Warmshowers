//
//  HostListTableViewCell.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 13/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

class HostListTableViewCell: UITableViewCell {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var availibleDot: WSColoredDot!
    
    var uid: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nameLabel.text = nil
        locationLabel.text = nil
        profileImage.image = nil
    }
    
    func setNotAvailible(notAvailible: Bool?) {
        
        guard let notAvailible = notAvailible else {
            availibleDot?.color = UIColor.whiteColor()
            return
        }
        
        if notAvailible {
            availibleDot?.color = WSColor.NotAvailable
        } else {
            availibleDot?.color = WSColor.Available
        }
    }
}
