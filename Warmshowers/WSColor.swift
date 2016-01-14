//
//  WSColor.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 14/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

struct WSColor {
    
    // General styling colors
    static var LightGrey = WSColor.colorFromHexString("F4F6F6")
    static var Blue = WSColor.colorFromHexString("266ACF")
    static var Green = WSColor.colorFromHexString("009835")
    
    // Positivity colors
    static var Positive = WSColor.colorFromHexString("019E3C")
    static var Neutral = UIColor.orangeColor()
    static var Negative = UIColor.redColor()
    
    // Availiblity colors
    static var Availible = WSColor.colorFromHexString("019E3C")
    static var NotAvailible = UIColor.redColor()
    
    // OS colours
    static var NavbarGrey = UIColor(red: 247.0/255.0, green: 247.0/255.0, blue: 247.0/255.0, alpha: 1)
    
    // Returns a UIColor from a hex color as a string e.g. "F493A2"
    static func colorFromHexString(hex: String) -> UIColor {
        
        func hexToDecimal(hex: String) -> CGFloat {
            return CGFloat(strtoul(hex, nil, 16))
        }
        
        let redRange = Range<String.Index>(start:hex.startIndex.advancedBy(0), end: hex.startIndex.advancedBy(2))
        let greenRange = Range<String.Index>(start:hex.startIndex.advancedBy(2), end: hex.startIndex.advancedBy(4))
        let blueRange = Range<String.Index>(start:hex.startIndex.advancedBy(4), end: hex.startIndex.advancedBy(6))
        
        let red = hexToDecimal(hex.substringWithRange(redRange))/255
        let green = hexToDecimal(hex.substringWithRange(greenRange))/255
        let blue = hexToDecimal(hex.substringWithRange(blueRange))/255
        
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
}
