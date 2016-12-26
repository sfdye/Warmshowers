//
//  ProgressHUD.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 25/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit
import MBProgressHUD

class ProgressHUD {
    
    /** Shows the progress HUD covering the whole screen. */
    static func show(_ label: String?) {
        if let view = (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.view {
            DispatchQueue.main.async(execute: { [unowned view] in
                let hud = MBProgressHUD.showAdded(to: view, animated: true)
                hud.label.text = label
                hud.WSStyle()
                })
        }
    }
    
    static func show(_ view: UIView?, label: String?) {
        DispatchQueue.main.async(execute: {
            guard let view = view else { return }
            let hud = MBProgressHUD.showAdded(to: view, animated: true)
            hud.label.text = label
            hud.WSStyle()
            })
    }
    
    /** Hides the progress HUD. */
    static func hide() {
        if let view = (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.view {
            DispatchQueue.main.async(execute: { [unowned view] in
                MBProgressHUD.hide(for: view, animated: true)
            })
        }
    }
    
    static func hide(_ view: UIView?) {
        DispatchQueue.main.async(execute: {
            guard let view = view else { return }
            MBProgressHUD.hide(for: view, animated: true)
        })
    }
    
}

private extension MBProgressHUD {
    
    func WSStyle() {
        self.bezelView.color = WarmShowersColor.NavbarGrey
        self.label.textColor = WarmShowersColor.Green
        self.label.font = WarmShowersFont.SueEllenFrancisco(22)
        self.removeFromSuperViewOnHide = true
        backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3)
    }
}
