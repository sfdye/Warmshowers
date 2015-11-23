//
//  SpinnerView.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 20/11/15.
//  Copyright © 2015 Rajan Fernandez. All rights reserved.
//

import UIKit

class SpinnerView: UIView {
    
    let activityIndicator = UIActivityIndicatorView.init(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
    let overlay = UIView()
//    let parentView = self.parent()
    
    func setup () {
        self.overlay.frame = UIScreen.mainScreen().bounds
        self.overlay.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
        self.activityIndicator.center = overlay.center;
        overlay.addSubview(activityIndicator)
//        self.parent().addSubview(self)
    }
    
    func parent () -> UIView? {
        return self.superview
    }
    
    func start () {
        self.hidden = false
//        self.overlay.hidden
        activityIndicator.startAnimating()
    }
    
    func stop () {
        overlay.hidden = true
        activityIndicator.stopAnimating()
    }

}
