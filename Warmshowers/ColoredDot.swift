//
//  ColouredDot.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 19/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

@IBDesignable
class ColoredDot: UIView {
    
    @IBInspectable var color: UIColor = UIColor.blueColor()
    
    override func drawRect(rect: CGRect) {
        let path = UIBezierPath(ovalInRect: rect)
        color.setFill()
        path.fill()
    }
    
}
