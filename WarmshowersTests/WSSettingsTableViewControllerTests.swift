//
//  WSSettingsTableViewControllerTests.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 30/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import XCTest
@testable import Warmshowers

class WSSettingsTableViewControllerTests: XCTestCase {
    
    let storyboard = UIStoryboard.init(name: "Settings", bundle: nil)
    let storyboardID = SBID_Settings
    
    // Test objects
    var settingsTableViewController: WSSettingsTableViewController?
    var mockNavigationDelegate: WSMOCKNavigationDelegate!
    var mockAPICommunicator: WSMOCKAPICommunicator!
    var mockAlertDelegate: WSMOCKAlertDelegate!
    
    override func setUp() {
        super.setUp()
        // Load the view controller
        settingsTableViewController = storyboard.instantiateViewControllerWithIdentifier(storyboardID) as? WSSettingsTableViewController
        XCTAssertNotNil(settingsTableViewController, "Failed to instantiate with storyboard ID: \(storyboardID).")
        
        // Initialise mocks
        mockNavigationDelegate = WSMOCKNavigationDelegate()
        mockAPICommunicator = WSMOCKAPICommunicator()
        mockAlertDelegate = WSMOCKAlertDelegate()
        
        // Set the mocks that don't require the view
        settingsTableViewController?.navigation = mockNavigationDelegate
        settingsTableViewController?.api = mockAPICommunicator
        settingsTableViewController?.alert = mockAlertDelegate
    }
    
    override func tearDown() {
        
        super.tearDown()
    }
    
    func testTitleIsSetCorrectly() {
        // given
        
        // when
        
        // then
        let expectedTitle = "Settings"
        let title = settingsTableViewController?.navigationItem.title
        XCTAssertEqual(title, expectedTitle, "Settings screen has title '\(title)', expected '\(expectedTitle)'.")
    }
}
