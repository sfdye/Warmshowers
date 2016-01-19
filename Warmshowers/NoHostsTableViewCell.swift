//
//  NoHostsTableViewCell.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 18/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

class NoHostsTableViewCell: UITableViewCell {
    
    @IBOutlet var noHostsLabel: UILabel!

    override func awakeFromNib() {
        noHostsLabel.text = "No Hosts"
        noHostsLabel.font = WSFont.SueEllenFrancisco(22)
        noHostsLabel.textColor = WSColor.MediumGrey
    }
}
