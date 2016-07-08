//
//  WSHostSearchViewControllerTests.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 8/07/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import XCTest
@testable import Warmshowers

class WSHostSearchViewControllerTests: XCTestCase {
    
    let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
    let storyboardID = SBID_HostSearch
    
    // Test objects
    var hostSearchViewController: WSHostSearchViewController?
    var mockSessionState: WSMOCKSessionState!
    var mockNavigationDelegate: WSMOCKNavigationDelegate!
    var mockAPICommunicator: WSMOCKAPICommunicator!
    var mockAlertDelegate: WSMOCKAlertDelegate!
    let request = WSAPIRequest(endPoint: .Login, withDelegate: WSAPICommunicator.sharedAPICommunicator, andRequester: nil)
    
    override func setUp() {
        super.setUp()
        // Load the view controller
        hostSearchViewController = storyboard.instantiateViewControllerWithIdentifier(storyboardID) as? WSHostSearchViewController
        XCTAssertNotNil(hostSearchViewController, "Failed to instantiate with storyboard ID: \(storyboardID).")
        
        // Initialise mocks
        mockSessionState = WSMOCKSessionState()
        mockNavigationDelegate = WSMOCKNavigationDelegate()
        mockAPICommunicator = WSMOCKAPICommunicator()
        mockAlertDelegate = WSMOCKAlertDelegate()
        
        // Set the mocks that don't require the view
        hostSearchViewController?.session = mockSessionState
        hostSearchViewController?.api = mockAPICommunicator
        hostSearchViewController?.alert = mockAlertDelegate
    }
    
    override func tearDown() {
        hostSearchViewController = nil
        mockSessionState = nil
        mockNavigationDelegate = nil
        mockAPICommunicator = nil
        mockAlertDelegate = nil
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
