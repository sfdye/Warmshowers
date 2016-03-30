//
//  HostSearchViewController+WSMapControllerDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 18/03/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

extension HostSearchViewController : WSMapControllerDelegate {
    
    func willBeginUpdates() {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.infoLabel.text = "Updating ..."
        }
    }
    
    func didFinishUpdates() {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.infoLabel.text = nil
        }
    }
}