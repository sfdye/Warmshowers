//
//  SpinnerTableViewCell.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 18/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

class SpinnerTableViewCell: UITableViewCell {
    
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        spinner.hidesWhenStopped = true
        spinner.startAnimating()
    }
    
    func startSpinner() {
        spinner.startAnimating()
    }
    
    func stopSpinner() {
        spinner.stopAnimating()
    }

}
