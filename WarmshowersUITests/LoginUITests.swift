//
//  LoginUITests.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 28/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import XCTest

class LoginUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testLoginActions() {
        
        let app = XCUIApplication()
        
        let userNameField = app.textFields["Username or Email"]
        XCTAssertNotNil(userNameField, "Username field not found on login screen.")
        userNameField.tap()
        
        let passwordSecureTextField = app.secureTextFields["Password"]
        XCTAssertNotNil(passwordSecureTextField, "Password field not found on login screen.")
        passwordSecureTextField.tap()
        
        app.buttons["Login"].tap()
        
        let dismissButton = app.alerts["Login error"].collectionViews.buttons["Dismiss"]
        dismissButton.tap()
        
        app.buttons["Create an account"].tap()
    }
    
}
