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
    
    /**
    The time (in seconds) at which cached user location data is deemed to old and should be updated from either the store or from downloading fresh data.
    Set to 15 minutes.
    */
    let UpdateThresholdTime: Double = 60.0 * 15.0
    
    /** The tile longitude index */
    var x: UInt
    
    /** The tile latitude index */
    var y: UInt
    
    /** The tile zoom index */
    var z: UInt
    
    /** Hosts whose location is within the bounds of the map tile. */
    var users: [WSUserLocation]
    
    /** The quad key (base on Bing maps) to uniquely identify tiles */
    var quadKey: String
    
    /** The time that the users on the tile were last updated. */
    var last_updated: NSDate?
    
    /** The minimum longitude bound of the tile. */
    var minimumLongitude: Double {
        return Double(x) / pow(2.0, Double(z)) * 360.0 - 180.0
    }
    
    /** The maximum longitude bound of the tile. */
    var maximumLongitude: Double {
        return Double(x + 1) / pow(2.0, Double(z)) * 360.0 - 180.0
    }
    
    /** The minimum latitude bound of the tile. */
    var minimumLatitude: Double {
        return degrees(atan(sinh(M_PI - Double(y + 1) / pow(2.0, Double(z)) * 2 * M_PI)))
    }
    
    /** The maximum latitude bound of the tile. */
    var maximumLatitude: Double {
        return degrees(atan(sinh(M_PI - Double(y) / pow(2.0, Double(z)) * 2 * M_PI)))
    }
    
    var centerLongitude: Double {
        return (Double(x) + 0.5) / pow(2.0, Double(z)) * 360.0 - 180.0
    }
    
    var centerLatitude: Double {
        return degrees(atan(sinh(M_PI - (Double(y) + 0.5) / pow(2.0, Double(z)) * 2 * M_PI)))
    }
    
    /** Returns the coordinate limits of a map tile. */
    var regionLimits: [String: String] {
        return [
            "minlat": String(minimumLatitude),
            "maxlat": String(maximumLatitude),
            "minlon": String(minimumLongitude),
            "maxlon": String(maximumLongitude),
            "centerlat": String(centerLatitude),
            "centerlon": String(centerLongitude)
        ]
    }
    
    /** Returns the four quadrant sub-tiles on the tile. */
    var subtiles: [WSMapTile] {
        let z = self.z + 1
        let xMin = self.x * 2
        let yMin = self.y * 2
        var tiles = [WSMapTile]()
        for x in (xMin)...(xMin + 1) {
            for y in (yMin)...(yMin + 1) {
                tiles.append(WSMapTile(x: x, y: y, z: z)!)
            }
        }
        return tiles
    }
    
    /** Returns true if the user data on the tile is older that the expiry time. */
    var needsUpdating: Bool {
        guard let last_updated = last_updated else { return true }
        return abs(last_updated.timeIntervalSinceNow) > UpdateThresholdTime
    }

    
    // MARK: Hashable
    
    var hashValue: Int { return quadKey.hashValue }
    
    
    // MARK: Initialisers
    
    /**
     Initialises a WSMapTile with x, y, z indexes as per google maps tile numbering.
     e.g. at zoom level 0 (z = 0) there are only 1 x 1 tiles in the world so x = 0, and y = 0
     */
    init?(x: UInt, y: UInt, z: UInt) {
        let n = 1 << z
        guard x < n else { return nil }
        guard y < n else { return nil }
        self.x = x
        self.y = y
        self.z = z
        self.users = [WSUserLocation]()
        self.quadKey = WSMapTile.quadKeyFromX(x, y: y, z: z)
    }
    
    convenience init?(latitude: CLLocationDegrees, longitude: CLLocationDegrees, zoom: UInt) {

        func moveDegrees(inout degrees: CLLocationDegrees, intoRangeWithLowerBound lowerBound: Double, andUpperBound upperBound: Double) {
            let range = upperBound - lowerBound
            while degrees < lowerBound {
                degrees += range
            }
            while degrees >= upperBound {
                degrees -= range
            }
        }
        
        // Limit latitude to the domain of -85 < lat < 85. These are the limits of mercator projection.
        let lat = latitude
        if lat < -85.0 { return nil }
        if lat > 85.0 { return nil }
        
        // Ensure longitude is on the domain of -180 < lon < 180
        var lon = longitude
        moveDegrees(&lon, intoRangeWithLowerBound: -180.0, andUpperBound: 180.0)
        
        let x = UInt(floor((lon + 180.0) / 360.0 * Double(1 << zoom)))
        let y = UInt(floor((1.0 - log( tan(lat * M_PI / 180.0) + 1.0 / cos(lat * M_PI / 180.0)) / M_PI) / 2.0 * pow(2.0, Double(zoom))))
        self.init(x: x, y: y, z: zoom)
    }
    
    /** Returns the quad key for the given tile index */
    private class func quadKeyFromX(x: UInt, y: UInt, z: UInt) -> String {
        
        func moveInt(inout int: UInt, intoRangeWithLowerBound lowerBound: UInt, andUpperBound upperBound: UInt) {
            let range = upperBound - lowerBound
            while int < lowerBound {
                int += range
            }
            while int > upperBound {
                int -= range
            }
        }
        
        func paddedBinaryIntArray(x: UInt, length: UInt) -> [Int] {
            var binaryStringArray = String(x, radix:2).characters.map { (character) -> String in
                String(character)
            }
            while binaryStringArray.count < Int(length) {
                binaryStringArray.insert("0", atIndex: 0)
            }
            let binaryIntArray = binaryStringArray.map { (string) -> Int in
                return Int(string) ?? 0
            }
            return binaryIntArray
        }
        
        let n = UInt(pow(2.0, Double(z)))
        var x = x
        var y = y
        moveInt(&x, intoRangeWithLowerBound: 0, andUpperBound: n)
        moveInt(&y, intoRangeWithLowerBound: 0, andUpperBound: n)

        let xBinary = paddedBinaryIntArray(UInt(Double(x) % pow(2.0, Double(z))), length: z)
        let yBinary = paddedBinaryIntArray(UInt(Double(y) % pow(2.0, Double(z))), length: z)
        var quadKeyString = ""
        for index in 0..<Int(z) {
            quadKeyString += String(xBinary[index] + 2 * yBinary[index])
        }
        return quadKeyString
    }
    
    /** Factory method to return all the map tiles that are it a given map region */
    class func tilesForMapRegion(region: MKCoordinateRegion, atZoomLevel z: UInt) -> [WSMapTile]? {
        
        // Only return tiles within the latitude range pf -85 < lat < 85.
        let minLat = max(region.minimumLatitude, -85.0)
        let maxLat = min(region.maximumLatitude, 85.0)
        let minLon = region.minimumLongitude
        let maxLon = region.maximumLongitude
        
        // Return nil if on the tiles in the corners of the region are out of bounds and hence can not be initialized.
        guard
            let northWest = WSMapTile(latitude: maxLat, longitude: minLon, zoom: z),
            let southEast = WSMapTile(latitude: minLat, longitude: maxLon, zoom: z)
            else {
                return nil
        }
        
        let n = 1 << z
        var xRange: [UInt]
        let yRange = northWest.y...southEast.y
        if southEast.x < northWest.x {
            xRange = Array(northWest.x...n) + Array(0...southEast.x)
        } else {
            xRange = Array(northWest.x...southEast.x)
        }
        
        var tiles = [WSMapTile]()
        for x in xRange {
            for y in yRange {
                if let tile = WSMapTile(x: x, y: y, z: z) {
                    tiles.append(tile)
                }
            }
        }
        return tiles
    }
    
    /** Returns a polygon that overlays the tile. */
    func polygon() -> MKPolygon {
        var vertices = [CLLocationCoordinate2D]()
        vertices.append(CLLocationCoordinate2D(latitude: maximumLatitude, longitude: minimumLongitude))
        vertices.append(CLLocationCoordinate2D(latitude: maximumLatitude, longitude: maximumLongitude))
        vertices.append(CLLocationCoordinate2D(latitude: minimumLatitude, longitude: maximumLongitude))
        vertices.append(CLLocationCoordinate2D(latitude: minimumLatitude, longitude: minimumLongitude))
        let polygon = MKPolygon(coordinates: &vertices, count: 4)
        polygon.title = quadKey
        return polygon
    }
    
    private func radians(degrees: Double) -> Double {
        return degrees * M_PI / 180.0
    }
    
    private func degrees(radians: Double) -> Double {
        return radians * 180.0 / M_PI
    }
    
}

func == (lhs: WSMapTile, rhs: WSMapTile) -> Bool {
    return lhs.quadKey == rhs.quadKey
}
