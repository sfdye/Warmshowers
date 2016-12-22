//
//  PlaceholderTableViewCell.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 18/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

class PlaceholderTableViewCell: UITableViewCell {
    
    @IBOutlet var placeholderLabel: UILabel!

    override func awakeFromNib() {
        placeholderLabel.text = ""
        placeholderLabel.font = WarmShowersFont.SueEllenFrancisco(22)
        placeholderLabel.textColor = WarmShowersColor.MediumGrey
    }
}
