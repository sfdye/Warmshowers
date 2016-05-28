//
//  WSMapTile.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 8/03/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit
import MapKit

class WSMapTile: Hashable {
    
    var x: UInt
    var y: UInt
    var z: UInt
    var quadKey: Int

    
    // MARK: Hashable
    
    var hashValue: Int { return quadKey }
    
    
    // MARK: Initialisers
    
    /**
     Initialises a WSMapTile with x, y, z indexes as per google maps tile numbering.
     e.g. at zoom level 0 (z = 0) there are only 1 x 1 tiles in the world so x = 0, and y = 0
     */
    init(x: UInt, y: UInt, z: UInt) {
        self.x = x
        self.y = y
        self.z = z
        
        // Calculate the store the quad key to identify the tile.
        func paddedBinaryIntArray(x: UInt, length: UInt) -> [UInt] {
            var binaryStringArray = String(x, radix:2).characters.map { (character) -> String in
                String(character)
            }
            while binaryStringArray.count < Int(length) {
                binaryStringArray.insert("0", atIndex: 0)
            }
            let binaryIntArray = binaryStringArray.map { (string) -> UInt in
                return UInt(string) ?? 0
            }
            return binaryIntArray
        }
        let xBinary = paddedBinaryIntArray(x, length: z)
        let yBinary = paddedBinaryIntArray(y, length: z)
        var quadKeyString = ""
        for index in 0..<Int(z) {
            quadKeyString += String(xBinary[index] + 2 * yBinary[index])
        }
        self.quadKey = Int(quadKeyString)!
    }
    
    convenience init(lon: CLLocationDegrees, lat: CLLocationDegrees, zoom: UInt) {
        let x = UInt(floor((lon + 180.0) / 360.0 * pow(2.0, Double(zoom))))
        let y = UInt(floor((1.0 - log(tan(lat * M_PI / 180.0) + 1.0 / cos(lat * M_PI / 180.0)) / M_PI) * pow(2.0, Double(zoom) - 1.0)))
        self.init(x: x, y: y, z: zoom)
    }
    
    /** Factory method to return an array of map tiles from x and y tile index ranges at a given zoom level */
    class func tilesWithXRange(xRange: Range<UInt>, yRange: Range<UInt>, atZoomLevel z: UInt) -> [WSMapTile]? {
        var tiles = [WSMapTile]()
        for x in xRange {
            for y in yRange {
                tiles.append(WSMapTile(x: x, y: y, z: z))
            }
        }
        return tiles
    }
    
    /** Factory method to return all the map tiles that are it a given map region */
    class func tilesForMapRegion(region: MKCoordinateRegion, atZoomLevel z: UInt) -> [WSMapTile]? {
        print("lat: \(region.minimumLatitude), \(region.maximumLatitude), lon: \(region.minimumLongitude), \(region.maximumLongitude)")
        
        let northWest = WSMapTile(lon: region.minimumLongitude, lat: region.maximumLatitude, zoom: z)
        northWest.printTile()
        let southEast = WSMapTile(lon: region.maximumLongitude, lat: region.minimumLatitude, zoom: z)
        southEast.printTile()
        return WSMapTile.tilesWithXRange(northWest.x...southEast.x, yRange: northWest.y...southEast.y, atZoomLevel: z)
    }

    
    
//    var minimumLatitude: Double {
//        return self.region.center.latitude - self.region.span.latitudeDelta / 2.0
//    }
//    
//    var maximumLatitude: Double {
//        return self.region.center.latitude + self.region.span.latitudeDelta / 2.0
//    }
//    
//    var minimumLongitude: Double {
//        return self.region.center.longitude - self.region.span.longitudeDelta / 2.0
//    }
//    
//    var maximumLongitude: Double {
//        return self.region.center.longitude + self.region.span.longitudeDelta / 2.0
//    }
    
    // Returns the coordinate limits of a map tile
    // Used for getting hosts in the current displayed region in getHostDataForMapView
    //
    func regionLimits(limit: Int = 100) -> [String: String] {
//
//        let regionLimits: [String: String] = [
//            "minlat": String(minimumLatitude),
//            "maxlat": String(maximumLatitude),
//            "minlon": String(minimumLongitude),
//            "maxlon": String(maximumLongitude),
//            "centerlat": String(region.center.latitude),
//            "centerlon": String(region.center.longitude)
//        ]
//        
        return [String: String]()
//        return regionLimits
    }
    
    /** Utility method for debugging */
    func printTile() {
        print("x: \(x), y: \(y), z: \(z)")
    }
    
}

func == (lhs: WSMapTile, rhs: WSMapTile) -> Bool {
    return lhs.hashValue == rhs.hashValue
}
