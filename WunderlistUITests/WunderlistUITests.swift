//
//  WunderlistUITests.swift
//  WunderlistUITests
//
//  Created by Kenny on 6/21/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import XCTest

class WunderlistUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
        let app = XCUIApplication()
        app.launchArguments = ["UITesting"]
        app.launch()
    }
    
    enum Identifier: String {
        
        case loginUserTextField = "LoginViewController.usernameTextField"
        case loginEmailTextField = "LoginViewController.emailController.usernameTextField"
        case loginButton =  "LoginViewController.loginButton"
        case cellTitleLabel = "TodoTableViewCell.titleLabel"
        case cellCompleteButton
            = "TodoTableViewCell.completeButton"
        case createTitleLabel = "CreateTodoViewController.titleTextField"
        case createBodyTextView = "CreateTodoViewController.bodyTextView"
        case detailTitleTextField = "ToDoDetailViewController.titleTextField"
        case detailBodyTextView = "TodoDetailViewController.bodyTextView"
    }
    
    private var testUsername = "mockUser"
    private var testEmail = "mock@email.com"
    private var testPassword = "password"
    private var testTitle = "Title"
    private var testBody = "Body"

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
}
