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
    
    let storyboard = UIStoryboard.init(name: "HostSearch", bundle: nil)
    let storyboardID = CreateFeedbackSBID
    
    // Test objects
//    var mockAPICommunicator = WSMOCKAPICommunicator.sharedAPICommunicator
    var createFeedbackViewController: WSCreateWSFeedbackTableViewController?
    
    override func setUp() {
        super.setUp()
        
        // Test the view can be loaded from the storyboard.
        createFeedbackViewController = storyboard.instantiateViewControllerWithIdentifier(storyboardID) as? WSCreateWSFeedbackTableViewController
        XCTAssertNotNil(createFeedbackViewController, "Failed to instantiate with storyboard ID: \(storyboardID).")
        
//        // Attach the mock api communicator.
//        mockAPICommunicator = WSMOCKAPICommunicator.sharedAPICommunicator
//        createFeedbackViewController?.apiCommunicator = mockAPICommunicator
//        print(createFeedbackViewController?.apiCommunicator)
    }
    
    override func tearDown() {
        createFeedbackViewController = nil
//        mockAPICommunicator.reset()
        super.tearDown()
    }
    
    func testSubmitFeedbackAction() {
        
        createFeedbackViewController?.feedback.recommendedUserName = "bob"
        createFeedbackViewController?.feedback.body = "test"
        
        createFeedbackViewController?.sumbitButtonPressed(nil)
        
        
        
//        print(mockAPICommunicator.sendFeedbackCalled)
        
//        XCTAssertFalse(mockAPICommunicator.sendFeedbackCalled, "Feedback should not be submitted without a username.")
        
        
        XCTAssertFalse(mockAPICommunicator.sendFeedbackCalled, "Feedback should not be submitted without a recomendation body.")
        
    }

}
