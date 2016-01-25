//
//  WSProgressHUD.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 25/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation
import MBProgressHUD

class WSProgressHUD {
    
    // Shows the progress hud coving the whoel screen
    //
    static func show(label: String) {
        let view = (UIApplication.sharedApplication().delegate as! AppDelegate).window?.rootViewController?.view
        let hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
        hud.color = WSColor.NavbarGrey
        hud.labelText = label
        hud.labelColor = WSColor.Green
        hud.labelFont = WSFont.SueEllenFrancisco(22)
        hud.activityIndicatorColor = WSColor.DarkBlue
        hud.dimBackground = true
        hud.removeFromSuperViewOnHide = true
    }
    
    // Hides the progress hud
    //
    static func hide() {
        let view = (UIApplication.sharedApplication().delegate as! AppDelegate).window?.rootViewController?.view
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            MBProgressHUD.hideHUDForView(view, animated: true)
        })
    }
    
}