//
//  MapTile.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 24/12/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit
import MapKit

public class MapTile: Hashable {
    
    /**
     The time (in seconds) at which cached user location data is deemed to old and should be updated from either the store or from downloading fresh data.
     Set to 30 minutes.
     */
    let UpdateThresholdTime: Double = 60.0 * 30.0
    
    /** The tile longitude index */
    var x: UInt
    
    /** The tile latitude index */
    var y: UInt
    
    /** The tile zoom index */
    public var z: UInt
    
    /** Hosts whose location is within the bounds of the map tile. */
    public var users: Set<UserLocation> {
        didSet {
            last_updated = Date()
        }
    }
    
    /** The quad key (base on Bing maps) to uniquely identify tiles */
    public var quadKey: String
    
    /** The time that the users on the tile were last updated. */
    var last_updated: Date?
    
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
        return degrees(atan(sinh(Double.pi - Double(y + 1) / pow(2.0, Double(z)) * 2 * Double.pi)))
    }
    
    /** The maximum latitude bound of the tile. */
    var maximumLatitude: Double {
        return degrees(atan(sinh(Double.pi - Double(y) / pow(2.0, Double(z)) * 2 * Double.pi)))
    }
    
    var centerLongitude: Double {
        let x_double = Double(x)
        let z_double = Double(z)
        return (x_double + 0.5) / pow(2.0, z_double) * 360.0 - 180.0
    }
    
    var centerLatitude: Double {
        return degrees(atan(sinh(Double.pi - (Double(y) + 0.5) / pow(2.0, Double(z)) * 2 * Double.pi)))
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
    public var subtiles: [MapTile] {
        let z = self.z + 1
        let xMin = self.x * 2
        let yMin = self.y * 2
        var tiles = [MapTile]()
        for x in (xMin)...(xMin + 1) {
            for y in (yMin)...(yMin + 1) {
                tiles.append(MapTile(x: x, y: y, z: z)!)
            }
        }
        return tiles
    }
    
    /** Returns true if the user data on the tile is older that the expiry time. */
    public var needsUpdating: Bool {
        guard let last_updated = last_updated else { return true }
        return abs(last_updated.timeIntervalSinceNow) > UpdateThresholdTime
    }
    
    
    // MARK: Hashable
    
    public var hashValue: Int { return quadKey.hashValue }
    
    
    // MARK: Initialisers
    
    /**
     Initialises a MapTile with x, y, z indexes as per google maps tile numbering.
     e.g. at zoom level 0 (z = 0) there are only 1 x 1 tiles in the world so x = 0, and y = 0
     */
    init?(x: UInt, y: UInt, z: UInt) {
        let n = 1 << z
        guard x < n else { return nil }
        guard y < n else { return nil }
        self.x = x
        self.y = y
        self.z = z
        self.users = Set<UserLocation>()
        self.quadKey = MapTile.quadKeyFromX(x, y: y, z: z)
    }
    
    convenience init?(latitude: CLLocationDegrees, longitude: CLLocationDegrees, zoom: UInt) {
        
        func moveDegrees(_ degrees: inout CLLocationDegrees, intoRangeWithLowerBound lowerBound: Double, andUpperBound upperBound: Double) {
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
        let tanpart = tan(lat * Double.pi / 180.0)
        let cospart = cos(lat * Double.pi / 180.0)
        let sub = tanpart + 1.0 / cospart
        let y = UInt(floor((1.0 - log(sub) / Double.pi) / 2.0 * pow(2.0, Double(zoom))))
        
        self.init(x: x, y: y, z: zoom)
    }
    
    /** Returns the quad key for the given tile index */
    fileprivate class func quadKeyFromX(_ x: UInt, y: UInt, z: UInt) -> String {
        
        func moveInt(_ int: inout UInt, intoRangeWithLowerBound lowerBound: UInt, andUpperBound upperBound: UInt) {
            let range = upperBound - lowerBound
            while int < lowerBound {
                int += range
            }
            while int > upperBound {
                int -= range
            }
        }
        
        func paddedBinaryIntArray(_ x: UInt, length: UInt) -> [Int] {
            var binaryStringArray = String(x, radix:2).characters.map { (character) -> String in
                String(character)
            }
            while binaryStringArray.count < Int(length) {
                binaryStringArray.insert("0", at: 0)
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
        
        let xBinary = paddedBinaryIntArray(UInt(Double(x).truncatingRemainder(dividingBy: pow(2.0, Double(z)))), length: z)
        let yBinary = paddedBinaryIntArray(UInt(Double(y).truncatingRemainder(dividingBy: pow(2.0, Double(z)))), length: z)
        var quadKeyString = ""
        for index in 0..<Int(z) {
            quadKeyString += String(xBinary[index] + 2 * yBinary[index])
        }
        return quadKeyString
    }
    
    fileprivate func xYFromQuadKey(_ quadKey: String) -> (x: UInt, y: UInt)? {
        guard let _ = Int(quadKey) else { return nil }
        let z = quadKey.characters.count
        let max = pow(2.0, Double(z))
        var x: UInt = 0
        var y: UInt = 0
        for (index, character) in quadKey.characters.enumerated() {
            let increment = UInt(max / pow(2.0, Double(index + 1)))
            let digit = Int(String(character))!
            switch digit {
            case 1:
                x += increment
            case 2:
                y += increment
            case 3:
                x += increment
                y += increment
            default:
                break
            }
        }
        return (x, y)
    }
    
    /** Factory method to return all the map tiles that are it a given map region. */
    public class func tilesForMapRegion(_ region: MKCoordinateRegion, atZoomLevel z: UInt) -> Set<MapTile>? {
        
        // Only return tiles within the latitude range pf -85 < lat < 85.
        let minLat = max(region.minimumLatitude, -85.0)
        let maxLat = min(region.maximumLatitude, 85.0)
        let minLon = region.minimumLongitude
        let maxLon = region.maximumLongitude
        
        // Return nil if on the tiles in the corners of the region are out of bounds and hence can not be initialized.
        guard
            let northWest = MapTile(latitude: maxLat, longitude: minLon, zoom: z),
            let southEast = MapTile(latitude: minLat, longitude: maxLon, zoom: z)
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
        
        var tiles = Set<MapTile>()
        for x in xRange {
            for y in yRange {
                if let tile = MapTile(x: x, y: y, z: z) {
                    tiles.insert(tile)
                }
            }
        }
        return tiles
    }
    
    public func isInRegion(_ region: MKCoordinateRegion) -> Bool {
        
        func moveDegrees(_ degrees: inout CLLocationDegrees, intoRangeWithLowerBound lowerBound: Double, andUpperBound upperBound: Double) {
            let range = upperBound - lowerBound
            while degrees < lowerBound {
                degrees += range
            }
            while degrees >= upperBound {
                degrees -= range
            }
        }
        
        guard
            !region.center.latitude.isNaN
                && !region.center.longitude.isNaN
                && !region.span.longitudeDelta.isNaN
                && !region.span.longitudeDelta.isNaN
            else { return false }
        
        var minLon = region.minimumLongitude
        moveDegrees(&minLon, intoRangeWithLowerBound: -180, andUpperBound: 180)
        var maxLon = region.maximumLongitude
        moveDegrees(&maxLon, intoRangeWithLowerBound: -180, andUpperBound: 180)
        var minLat = region.minimumLatitude
        moveDegrees(&minLat, intoRangeWithLowerBound: -90.0, andUpperBound: 90.0)
        var maxLat = region.maximumLatitude
        moveDegrees(&maxLat, intoRangeWithLowerBound: -90.0, andUpperBound: 90.0)
        
        return minimumLatitude < maxLat
            && maximumLatitude > minLat
            && minimumLongitude < maxLon
            && maximumLongitude > minLon
    }
    
    public func parentAtZoomLevel(_ z: UInt) -> MapTile? {
        guard z <= UInt(quadKey.characters.count) else { return nil }
        let index = quadKey.characters.index(quadKey.startIndex, offsetBy: Int(z))
        let parentQuadKey = quadKey.substring(to: index)
        guard let (x, y) = xYFromQuadKey(parentQuadKey) else { return nil }
        return MapTile(x: x, y: y, z: z)
    }
    
    /** Returns a polygon that overlays the tile. */
    public func polygon() -> MKPolygon {
        var vertices = [CLLocationCoordinate2D]()
        vertices.append(CLLocationCoordinate2D(latitude: maximumLatitude, longitude: minimumLongitude))
        vertices.append(CLLocationCoordinate2D(latitude: maximumLatitude, longitude: maximumLongitude))
        vertices.append(CLLocationCoordinate2D(latitude: minimumLatitude, longitude: maximumLongitude))
        vertices.append(CLLocationCoordinate2D(latitude: minimumLatitude, longitude: minimumLongitude))
        let polygon = MKPolygon(coordinates: &vertices, count: 4)
        polygon.title = quadKey
        return polygon
    }
    
    fileprivate func radians(_ degrees: Double) -> Double {
        return degrees * Double.pi / 180.0
    }
    
    fileprivate func degrees(_ radians: Double) -> Double {
        return radians * 180.0 / Double.pi
    }
    
}

public func == (lhs: MapTile, rhs: MapTile) -> Bool {
    return lhs.quadKey == rhs.quadKey
}

fileprivate extension MKCoordinateRegion {
    
    var minimumLatitude: Double {
        return center.latitude - span.latitudeDelta / 2.0
    }
    
    var maximumLatitude: Double {
        return center.latitude + span.latitudeDelta / 2.0
    }
    
    var minimumLongitude: Double {
        return center.longitude - span.longitudeDelta / 2.0
    }
    
    var maximumLongitude: Double {
        return center.longitude + span.longitudeDelta / 2.0
    }
    
}

fileprivate extension MKMapView {
    
    var minimumLatitude: Double {
        return self.region.center.latitude - self.region.span.latitudeDelta / 2.0
    }
    
    var maximumLatitude: Double {
        return self.region.center.latitude + self.region.span.latitudeDelta / 2.0
    }
    
    var minimumLongitude: Double {
        return self.region.center.longitude - self.region.span.longitudeDelta / 2.0
    }
    
    var maximumLongitude: Double {
        return self.region.center.longitude + self.region.span.longitudeDelta / 2.0
    }
    
    // Returns the current zoom level of the map
    // Zoom levels are as per google maps. 0 = the whole world, 1 = a quadrant of the whole world, ...
    //
    func zoomLevel() -> UInt {
        
        // Zoom levels are calculated as the
        let latitudeZoomLevel = UInt(log2(180.0 / self.region.span.latitudeDelta))
        let longitudeZoomLevel = UInt(log2(360.0 / self.region.span.longitudeDelta))
        return latitudeZoomLevel > longitudeZoomLevel ? latitudeZoomLevel : longitudeZoomLevel
    }
    
}

