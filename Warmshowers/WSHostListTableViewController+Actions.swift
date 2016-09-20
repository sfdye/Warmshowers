//
//  WSHostListTableViewController+Actions.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 11/07/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

extension WSHostListTableViewController {
    
    @IBAction func doneButtonPressed() {
        DispatchQueue.main.async { 
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}
