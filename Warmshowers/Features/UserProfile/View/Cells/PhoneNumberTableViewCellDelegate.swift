//
//  PhoneNumberTableViewCellDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 7/02/17.
//  Copyright © 2017 Rajan Fernandez. All rights reserved.
//

import Foundation

protocol PhoneNumberTableViewCellDelegate: class {
    
    func didSelectPhoneIcon(in cell: PhoneNumberTableViewCell)
    
    func didSelectMessageIcon(in cell: PhoneNumberTableViewCell)
    
}
