//
//  WSMapTileTests.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 25/05/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import XCTest
@testable import Warmshowers

class WSMapTileTests: XCTestCase {
    
    func testInitialiser() {
        // given
        
        // when
        let tile = WSMapTile(lon: -114.005724, lat: 46.872193, zoom: 13)
        
        // then
        let xExpectation: UInt = 1501
        let yExpectation: UInt = 2885
        let zExpectation: UInt = 13
        XCTAssertEqual(tile.x, xExpectation, "X-value for tile calculated incorrectly during initialisation.")
        XCTAssertEqual(tile.y, yExpectation, "Y-value for tile calculated incorrectly during initialisation")
        XCTAssertEqual(tile.z, zExpectation, "X-value for tile calculated incorrectly during initialisation.")
    }
    
    func testQuadTreeProperty() {
        let tile = WSMapTile(x: 1501, y: 2885, z: 13)
        let quadKeyExpectation: Int = 0212313011303
        XCTAssertEqual(tile.quadKey, quadKeyExpectation, "Quad tree value for tile calculated incorrectly. Expected \(quadKeyExpectation), \(tile.quadKey)")
    }
    
    func testTilesWithXRangeYRangeAndZoomLevel() {
        
        guard let tiles = WSMapTile.tilesWithXRange(0...1, yRange: 0...1, atZoomLevel: 1) else {
            XCTFail("No tiles generated with factory method.")
            return
        }
        
        XCTAssertEqual(tiles.count, 4, "Incorrect number of tiles not generated with factory method.")
    }
    
}
