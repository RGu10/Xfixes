//
//  xFixesUITests.swift
//  xFixesUITests
//
//  Created by Ryad on 28.06.17.
//  Copyright © 2017 Ryad. All rights reserved.
//

import XCTest

class xFixesUITests: XCTestCase {
	
	var app: XCUIApplication!
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app = XCUIApplication()
		app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testLogin() {
        // Use recording to get started writing UI tests.
		XCUIDevice.shared.orientation = .landscapeLeft
        // Use XCTAssert and related functions to verify your tests produce the correct results.
		print("xFixesUITests - testLogin")
		
		let LoginButton = app.buttons["Login"]
		let UsernameLabel = app.textFields["usernameLabel"]
		//let PasswordLabel = app.textFields["passwordLabel"]
		
		self.measure {
			XCTAssert(UsernameLabel.exists)
			//UsernameLabel.typeText("Ryad")
			//XCTAssert(PasswordLabel.exists)
			//PasswordLabel.typeText("0000")
			LoginButton.tap()
		}
    }
	
}
