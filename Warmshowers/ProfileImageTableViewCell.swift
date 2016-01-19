//
//  ProfileImageTableViewCell.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 27/12/15.
//  Copyright © 2015 Rajan Fernandez. All rights reserved.
//

import UIKit

class ProfileImageTableViewCell: UITableViewCell {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var noImageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImage.backgroundColor = WSColor.LightGrey
        noImageLabel.text = "No Profile Image"
        noImageLabel.font = WSFont.SueEllenFrancisco(22)
        noImageLabel.textColor = WSColor.MediumGrey
    }

}
