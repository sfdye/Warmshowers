//
//  WSLoginViewControllerTests.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 27/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import XCTest
@testable import Warmshowers

class WSLoginViewControllerTests: XCTestCase {
    
    let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
    let storyboardID = SBID_Login
    
    // Test objects
    var loginViewController: WSLoginViewController!
    var mockSessionState: WSMOCKSessionState!
    var mockNavigationDelegate: WSMOCKNavigationDelegate!
    var mockAPICommunicator: WSMOCKAPICommunicator!
    var mockAlertDelegate: WSMOCKAlertDelegate!
    let request = WSAPIRequest(endPoint: .Login, withDelegate: WSAPICommunicator.sharedAPICommunicator, andRequester: nil)
    
    override func setUp() {
        super.setUp()
        // Load the view controller
        loginViewController = storyboard.instantiateViewControllerWithIdentifier(storyboardID) as? WSLoginViewController
        XCTAssertNotNil(loginViewController, "Failed to instantiate with storyboard ID: \(storyboardID).")
        
        // Initialise mocks
        mockSessionState = WSMOCKSessionState()
        mockNavigationDelegate = WSMOCKNavigationDelegate()
        mockAPICommunicator = WSMOCKAPICommunicator()
        mockAlertDelegate = WSMOCKAlertDelegate()
        
        // Set the mocks that don't require the view
        loginViewController?.session = mockSessionState
        loginViewController?.navigation = mockNavigationDelegate
        loginViewController?.api = mockAPICommunicator
        loginViewController?.alert = mockAlertDelegate
    }
    
    override func tearDown() {
        loginViewController = nil
        mockSessionState = nil
        mockNavigationDelegate = nil
        mockAPICommunicator = nil
        mockAlertDelegate = nil
        super.tearDown()
    }
    
    func testAlertDelegateIsSet() {
        // given
        
        // when - the view is loaded
        _ = loginViewController?.view
        
        // then
        XCTAssertNotNil(loginViewController?.alert, "Alert delegate not set after loading the view.")
        XCTAssertNil(loginViewController?.presentedViewController, "Login view should not be presenting on load.")
    }
    
    func testUsernameFieldGaurd() {
        // given
        _ = loginViewController?.view
        
        // when - no password in entered
        loginViewController?.usernameTextField.text = "username"
        loginViewController?.passwordTextField.text = nil
        loginViewController?.loginButton(UIButton())
        
        // then
        XCTAssertFalse(mockAPICommunicator!.loginCalled, "Login request allowed with no username.")
        XCTAssertTrue(mockAlertDelegate!.presentAlertCalled, "User not alerted when no password was provided at login.")
    }
    
    func testPasswordFieldGuard() {
        // given
        _ = loginViewController?.view
        
        // when - no username is entered
        loginViewController?.usernameTextField.text = nil
        loginViewController?.passwordTextField.text = "password"
        loginViewController?.loginButton(UIButton())
        
        // then
        XCTAssertFalse(mockAPICommunicator!.loginCalled, "Login request allowed with no password.")
        XCTAssertTrue(mockAlertDelegate!.presentAlertCalled, "User not alerted when no username was provided at login.")
    }
    
    func testLoginAction() {
        // given
        _ = loginViewController?.view
        
        // when - a username and password are entered
        loginViewController?.usernameTextField.text = "username"
        loginViewController?.passwordTextField.text = "password"
        loginViewController?.loginButton(UIButton())
        
        // then
        XCTAssertTrue(mockAPICommunicator!.loginCalled, "API not contacted when the login button was pressed.")
    }
    
    func testCreateAccountButton() {
        // given
        
        // when - the create account button is used
        loginViewController?.createAccountButtonPressed(UIButton())
        
        // then
        XCTAssertTrue(mockNavigationDelegate!.openWarmshowersSignUpPageCalled, "Navigation delegate not notified to display the sign up page when the create account button is pressed.")
    }
    
    func testViewControllerResponsesToAPISuccess() {
        // given
        _ = loginViewController?.view
        
        // when
        loginViewController?.request(request, didSuceedWithData: nil)
        
        // then
        XCTAssertTrue(mockAPICommunicator!.getTokenCalled, "API not contacted with a token request after a successful login.")
        
        // when
        loginViewController?.request(request, didSuceedWithData: "mock token string")
        
        // then
        XCTAssertTrue(mockSessionState!.savePasswordForUsernameCalled, "Username and password not updated on a successful login.")
        XCTAssertTrue(mockNavigationDelegate!.showMainAppCalled, "Navigation delegate not notified to display main app after successful login.")
    }
    
    func testViewControllerResponsesToAPIFailure() {
        // given
        _ = loginViewController?.view
        
        // when
        loginViewController?.request(request, didFailWithError: WSAPICommunicatorError.NoData)
        
        // then
        XCTAssertTrue(mockAlertDelegate!.presentAlertCalled, "Alert delegate not notified on API error response.")
    }
}
