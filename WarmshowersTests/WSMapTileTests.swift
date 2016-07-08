//
//  WSMapTileTests.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 25/05/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import XCTest
import MapKit
@testable import Warmshowers

class WSMapTileTests: XCTestCase {
    
//    func testInitializerGuards() {
//        // given 
//        
//        // when - x is out of bounds for the zoom level
//        var tile = WSMapTile(x: 9, y: 5, z: 3)
//        
//        // then
//        var tileExpectation: WSMapTile? = nil
//        XCTAssertEqual(tile, tileExpectation, "X-value for tile calculated incorrectly during initialisation.")
//        
//        // when - y is out of bounds for the zoom level
//        tile = WSMapTile(x: 4, y: 9, z: 3)
//        
//        // then
//        tileExpectation = nil
//        XCTAssertEqual(tile, tileExpectation, "X-value for tile calculated incorrectly during initialisation.")
//        
//    }
    
    func testInitializer() {
        // given 
        
        // when - x and y are in bounds for the zoom level
        guard let tile = WSMapTile(x: 1501, y: 2885, z: 13) else {
            XCTFail("WSMapTile initializer failed.")
            return
        }
        
        // then
        let xExpectation: UInt = 1501
        let yExpectation: UInt = 2885
        let zExpectation: UInt = 13
        let quadKeyExpectation = "0212313011303"
        XCTAssertEqual(tile.x, xExpectation, "X-value for tile calculated incorrectly during initialisation.")
        XCTAssertEqual(tile.y, yExpectation, "Y-value for tile calculated incorrectly during initialisation")
        XCTAssertEqual(tile.z, zExpectation, "Z-value for tile calculated incorrectly during initialisation.")
        XCTAssertEqual(tile.quadKey, quadKeyExpectation, "Quad key value for tile calculated incorrectly.")
    }
    
    func testConvenienceInitializer() {
        // given
        
        // when - a tile is initialised with latitude and longitude coordinates.
        guard let tile = WSMapTile(latitude: 46.872193, longitude: -114.005724, zoom: 13) else {
            XCTFail("WSMapTile covenience initializer failed.")
            return
        }
        
        // then
        var xExpectation: UInt = 1501
        var yExpectation: UInt = 2885
        var zExpectation: UInt = 13
        XCTAssertEqual(tile.x, xExpectation, "X-value for tile calculated incorrectly during initialisation.")
        XCTAssertEqual(tile.y, yExpectation, "Y-value for tile calculated incorrectly during initialisation")
        XCTAssertEqual(tile.z, zExpectation, "Z-value for tile calculated incorrectly during initialisation.")
        
        // when - latitude is too high
        var largeLatitudeTile: WSMapTile? = WSMapTile(latitude: 90.0, longitude: -114.005724, zoom: 13)
        
        // then
        XCTAssertNil(largeLatitudeTile, "Tile initialised for and out of bounds latitude. Initializer should have returned nil.")
        
        // when - latitude is too low
        largeLatitudeTile = WSMapTile(latitude: -90.0, longitude: -114.005724, zoom: 13)
        
        // then
        XCTAssertNil(largeLatitudeTile, "Tile initialised for and out of bounds latitude. Initializer should have returned nil.")
        
        // when - longitude is out of the regular -180 - 180 degrees domain
        guard let largeLongitudeTile = WSMapTile(latitude: 45.0, longitude: 185.0, zoom: 3) else {
            XCTFail("WSMapTile covenience initializer failed.")
            return
        }
        
        // then
        xExpectation = 0
        yExpectation = 2
        zExpectation = 3
        XCTAssertEqual(largeLongitudeTile.x, xExpectation, "X-value for tile calculated incorrectly during initialisation.")
        XCTAssertEqual(largeLongitudeTile.y, yExpectation, "Y-value for tile calculated incorrectly during initialisation")
        XCTAssertEqual(largeLongitudeTile.z, zExpectation, "Z-value for tile calculated incorrectly during initialisation.")
    }
    
    func testTilesForMapRegion() {
        // given
        let center = CLLocationCoordinate2D(latitude: -65.0, longitude: 155.0)
        let span = MKCoordinateSpan(latitudeDelta: 30.0, longitudeDelta: 50.0)
        let mapRegion = MKCoordinateRegion(center: center, span: span)
        
        // when
        guard let tiles = WSMapTile.tilesForMapRegion(mapRegion, atZoomLevel: 3) else {
            XCTFail("WSMapTile covenience initializer failed.")
            return
        }
        
        // then
        let countExpectation = 9
        XCTAssertEqual(tiles.count, countExpectation, "Incorrect number of tiles generated by WSMapTile.tilesForMapRegion factory method.")
    }
    
    func testMinimumLatitude() {
        // given
        
        // when
        guard let tile = WSMapTile(x: 15, y: 9, z: 4) else {
            XCTFail("WSMapTile covenience initializer failed.")
            return
        }
        
        // then
        let minimumLatitudeExpectation = -40.97989806962013
        XCTAssertEqualWithAccuracy(tile.minimumLatitude, minimumLatitudeExpectation, accuracy: 0.01, "Tile minimum latitude is incorrect.")
    }
    
    func testMaximumLatitude() {
        // given
        
        // when
        guard let tile = WSMapTile(x: 15, y: 9, z: 4) else {
            XCTFail("WSMapTile covenience initializer failed.")
            return
        }
        
        // then
        let maximumLatitudeExpectation = -21.94
        XCTAssertEqualWithAccuracy(tile.maximumLatitude, maximumLatitudeExpectation, accuracy: 0.01, "Tile maximum latitude is incorrect.")
    }
    
    func testMinimumLongitude() {
        // given
        
        // when
        guard let tile = WSMapTile(x: 15, y: 9, z: 4) else {
            XCTFail("WSMapTile covenience initializer failed.")
            return
        }
        
        // then
        let minimumLongitudeExpectation = 157.5
        XCTAssertEqualWithAccuracy(tile.minimumLongitude, minimumLongitudeExpectation, accuracy: 0.01, "Tile minimum longitude is incorrect.")
    }
    
    func testMaximumLongitude() {
        // given
        
        // when
        guard let tile = WSMapTile(x: 15, y: 9, z: 4) else {
            XCTFail("WSMapTile covenience initializer failed.")
            return
        }
        
        // then
        let maximumLongitudeExpectation = 180.0
        XCTAssertEqualWithAccuracy(tile.maximumLongitude, maximumLongitudeExpectation, accuracy: 0.01, "Tile maximum longitude is incorrect.")
    }
    
    func testCenterLatitude() {
        // given
        
        // when
        guard let tile = WSMapTile(x: 15, y: 9, z: 4) else {
            XCTFail("WSMapTile covenience initializer failed.")
            return
        }
        
        // then
        let centerLatitudeExpectation = -31.95
        XCTAssertEqualWithAccuracy(tile.centerLatitude, centerLatitudeExpectation, accuracy: 0.01, "Tile center latitude is incorrect.")
    }
    
    func testCenterLongitude() {
        // given
        
        // when
        guard let tile = WSMapTile(x: 15, y: 9, z: 4) else {
            XCTFail("WSMapTile covenience initializer failed.")
            return
        }
        
        // then
        let centerLongitudeExpectation = 168.75
        XCTAssertEqualWithAccuracy(tile.centerLongitude, centerLongitudeExpectation, accuracy: 0.01, "Tile center longitude is incorrect.")
    }

}
