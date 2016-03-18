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
        if let view = (UIApplication.sharedApplication().delegate as! AppDelegate).window?.rootViewController?.view {
            let hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
            hud.label.text = label
            hud.WSStyle()
        }
    }
    
    static func show(view: UIView, label: String) {
        let hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
        hud.label.text = label
        hud.WSStyle()
    }
    
    // Hides the progress hud
    //
    static func hide() {
        if let view = (UIApplication.sharedApplication().delegate as! AppDelegate).window?.rootViewController?.view {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                MBProgressHUD.hideHUDForView(view, animated: true)
            })
        }
    }
    
    static func hide(view: UIView) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            MBProgressHUD.hideHUDForView(view, animated: true)
        })
    }
    
}

extension MBProgressHUD {
    
    func WSStyle() {
        self.bezelView.color = WSColor.NavbarGrey
        self.label.textColor = WSColor.Green
        self.label.font = WSFont.SueEllenFrancisco(22)
        self.activityIndicatorColor = WSColor.DarkBlue
        self.dimBackground = true
        self.removeFromSuperViewOnHide = true
    }
}