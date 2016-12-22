//
//  WarmShowersColor.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 14/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

struct WarmShowersColor {
    
    // General styling colors
    static var LightGrey = UIColor(hex: "F4F6F6")
    static var MediumGrey = UIColor.gray
    static var DarkGrey = UIColor.darkGray
    static var Blue = UIColor(hex: "266ACF")
    static var DarkBlue = UIColor(hex: "304767")
    static var Green = UIColor(hex: "009835")
    
    // Positivity colors
    static var Positive = UIColor(hex: "019E3C")
    static var Neutral = UIColor.orange
    static var Negative = UIColor.red
    
    // Availiblity colors
    static var Available = UIColor(hex: "019E3C")
    static var NotAvailable = UIColor.red
    
    // OS colours
    static var NavbarGrey = UIColor(red: 247.0/255.0, green: 247.0/255.0, blue: 247.0/255.0, alpha: 1)
    
}

/* UIColor convenience initialiser to generatre colors from hex codes. */
private extension UIColor {
    
    convenience init(hex: String) {
        
        func hexToDecimal(_ hex: String) -> CGFloat {
            return CGFloat(strtoul(hex, nil, 16))
        }
        
        let redRange = hex.characters.index(hex.startIndex, offsetBy: 0) ..< hex.characters.index(hex.startIndex, offsetBy: 2)
        let greenRange = hex.characters.index(hex.startIndex, offsetBy: 2) ..< hex.characters.index(hex.startIndex, offsetBy: 4)
        let blueRange = hex.characters.index(hex.startIndex, offsetBy: 4) ..< hex.characters.index(hex.startIndex, offsetBy: 6)
        
        let red = hexToDecimal(hex.substring(with: redRange))/255
        let green = hexToDecimal(hex.substring(with: greenRange))/255
        let blue = hexToDecimal(hex.substring(with: blueRange))/255
        
        self.init(red: red, green: green, blue: blue, alpha: 1)
    }
    
}

