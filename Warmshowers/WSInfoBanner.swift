//
//  WSInfoBanner.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 19/02/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit
import AFMInfoBanner

class WSInfoBanner {
    
    static func showNoInternetBanner() {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            let banner = AFMInfoBanner()
            banner.text = "No Internet Connection"
            banner.style = .Error
            banner.show(true)
        }
    }
    
    static func hideAll() {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            AFMInfoBanner.hideAll()
        }
    }
}