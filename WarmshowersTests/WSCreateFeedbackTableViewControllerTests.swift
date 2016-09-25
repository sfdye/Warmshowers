//
//  WSCreateFeedbackTableViewControllerTests.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 21/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import XCTest
@testable import Warmshowers

class WSCreateFeedbackTableViewControllerTests: XCTestCase {
    
    let storyboard = UIStoryboard.init(name: "UserProfile", bundle: nil)
    let storyboardID = SBID_CreateFeedback
    
    // Test objects
    var createFeedbackViewController: WSCreateFeedbackTableViewController?
    var mockAPICommunicator: WSMOCKAPICommunicator!
    var mockAlertDelegate: WSMOCKAlertDelegate!
    
    override func setUp() {
        super.setUp()
        // Load the view controller
        createFeedbackViewController = storyboard.instantiateViewController(withIdentifier: storyboardID) as? WSCreateFeedbackTableViewController
        XCTAssertNotNil(createFeedbackViewController, "Failed to instantiate with storyboard ID: \(storyboardID).")
        
        // Initialise mocks
        mockAPICommunicator = WSMOCKAPICommunicator()
        mockAlertDelegate = WSMOCKAlertDelegate()
        
        // Set the mocks that don't require the view
        createFeedbackViewController?.api = mockAPICommunicator
        createFeedbackViewController?.alert = mockAlertDelegate
    }
    
    override func tearDown() {
        createFeedbackViewController = nil
        mockAPICommunicator = nil
        mockAlertDelegate = nil
        super.tearDown()
    }
    
    func testRecommendedUserNameGuard() {
        // given
        createFeedbackViewController?.recommendation.recommendedUserName = nil
        createFeedbackViewController?.recommendation.body = "test"
        
        // when - feedback is submitted with no recommended user name
        createFeedbackViewController?.sumbitButtonPressed(nil)
        
        // then
        XCTAssertTrue(mockAlertDelegate!.presentAlertCalled, "User not alerted when no recommended user is set while creating feedback.")
    }
    
    func testFeedbackBodyGuard() {
        // given
        createFeedbackViewController?.recommendation.recommendedUserName = "bob"
        createFeedbackViewController?.recommendation.body = nil
        
        // when - feedback is submitted with no recommended user name
        createFeedbackViewController?.sumbitButtonPressed(nil)
        
        // then
        XCTAssertTrue(mockAlertDelegate!.presentAlertCalled, "User not alerted when attempting to submit feedback with no body.")
    }
    
    func testSubmitFeedback() {
        // given
        createFeedbackViewController?.recommendation.recommendedUserName = "bob"
        createFeedbackViewController?.recommendation.body = "feedback"
        
        // when - feedback is submitted with no recommended user name
        createFeedbackViewController?.sumbitButtonPressed(nil)
        
        // then
        XCTAssertTrue(mockAPICommunicator!.contactEndPointCalled, "API not contacted when the create feedback button was pressed.")
        XCTAssertEqual(mockAPICommunicator.contactedEndPoint, .CreateFeedback, "Wrong end point contacted for login.")
    }

}
