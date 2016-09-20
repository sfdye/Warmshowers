//
//  WSColouredDot.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 19/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

@IBDesignable
class WSColoredDot: UIView {
    
    @IBInspectable var color: UIColor = UIColor.blue
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath(ovalIn: rect)
        color.setFill()
        path.fill()
    }
    
}
