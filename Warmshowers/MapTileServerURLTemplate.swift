//
//  MapTemplate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 25/11/15.
//  Copyright © 2015 Rajan Fernandez. All rights reserved.
//

import UIKit

// Class to provie template URLs for different map tile servers
class MapTileServerURLTemplate {
    static let sharedInstance = MapTileServerURLTemplate()
    
    class func OpenStreetMaps() -> String {
        return "http://tile.openstreetmap.org/{z}/{x}/{y}.png"
    }
    
    class func OpenCycleMaps() -> String {
        return "http://tile.opencyclemap.org/cycle/{z}/{x}/{y}.png"
    }
}