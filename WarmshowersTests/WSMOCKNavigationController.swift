//
//  WSMOCKNavigationController.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 30/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

class WSMOCKNavigationController : UINavigationController {
    
    var dismissViewControllerAnimatedCalled = false
    
    override func dismissViewControllerAnimated(flag: Bool, completion: (() -> Void)?) {
        dismissViewControllerAnimatedCalled = true
    }
}