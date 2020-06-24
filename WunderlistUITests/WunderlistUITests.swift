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
        case loginEmailTextField = "LoginViewController.emailTextField"
        case loginPasswordTextField = "LoginViewController.passwordTextField"
        case loginButton =  "LoginViewController.loginButton"
        case cellTitleLabel = "TodoTableViewCell.titleLabel"
        case cellCompleteButton
            = "TodoTableViewCell.completeButton"
        case createTitleLabel = "CreateTodoViewController.titleTextField"
        case createBodyTextView = "CreateTodoViewController.bodyTextView"
        case detailTitleTextField = "ToDoDetailViewController.titleTextField"
        case detailBodyTextView = "TodoDetailViewController.bodyTextView"
        case passwordToggleButton = "toggleButton"
    }
    
    private var testUsername = "mockUser"
    private var testEmail = "mock@email.com"
    private var testPassword = "password"
    private var testTitle = "Title"
    private var testBody = "Body"
    
    private var app: XCUIApplication {
        return XCUIApplication()
    }
    
    
    private func textField(identifier: Identifier) -> XCUIElement {
        return app.textFields[identifier.rawValue]
    }
    
    private func textView(identifier: Identifier) -> XCUIElement {
        return app.textViews[identifier.rawValue]
    }
    
    private func buttons(identifier: Identifier) -> XCUIElement {
        return app.buttons[identifier.rawValue]
    }
    
    private var emailTextField: XCUIElement {
        return textField(identifier: .loginEmailTextField)
    }
    
    private var nameTextField: XCUIElement {
        return textField(identifier: .loginUserTextField)
    }
    
    private var passwordTextField: XCUIElement {
        return textField(identifier: .loginPasswordTextField)
    }
    
    private var loginButton: XCUIElement {
        return buttons(identifier: .loginButton)
    }
    
    private var enterButton: XCUIElement {
        return app.buttons["Return"]
    }
    
    private var securePasswordField: XCUIElement {
        return app.secureTextFields["LoginViewController.passwordTextField"]
        
    }
    
    private var toggleButton: XCUIElement {
        return buttons(identifier: .passwordToggleButton)
    }
    
    
    private func signInHelper() {
        let logInButton = app.segmentedControls.buttons["Log In"]
        XCTAssert(logInButton.isHittable)
        logInButton.tap()
        
        emailTextField.tap()
        XCTAssert(emailTextField.isHittable)
        emailTextField.typeText(testEmail)
        XCTAssert(emailTextField.value as? String == testEmail)
        
        passwordTextField.tap()
        passwordTextField.typeText(testPassword)
        XCTAssert(passwordTextField.value as? String == testPassword)
        
    }
    
    func testUserRegistration() throws {
        let registerButton = app.segmentedControls.buttons["Register"]
        XCTAssert(registerButton.isHittable)
        registerButton.tap()
        
        let userTextField = textField(identifier: .loginUserTextField)
        userTextField.tap()
        userTextField.typeText("User")
        XCTAssertEqual(userTextField.value as! String, "User")
        
        let emailTextField = textField(identifier: .loginEmailTextField)
        emailTextField.tap()
        emailTextField.typeText("test@email.com")
        XCTAssertEqual(emailTextField.value as! String, "test@email.com")
        enterButton.tap()

        let passwordTextField = securePasswordField
        XCTAssert(passwordTextField.isHittable)
        passwordTextField.tap()
        passwordTextField.typeText("password")
        XCTAssertNotNil(passwordTextField.value)
        passwordTextField.typeText("\n")
        
        let submitButton = buttons(identifier: .loginButton)
        submitButton.tap()
    }
    
    func testUserSignIn() throws {
        let signInButton = app.segmentedControls.buttons["Log In"]
        XCTAssert(signInButton.isHittable)
        signInButton.tap()
        
        let userTextField = textField(identifier: .loginUserTextField)
        userTextField.tap()
        userTextField.typeText("User")
        XCTAssertEqual(userTextField.value as! String, "User")
        
        let passwordTextField = securePasswordField
        XCTAssert(passwordTextField.isHittable)
        passwordTextField.tap()
        passwordTextField.typeText("password")
        XCTAssertNotNil(passwordTextField.value)
        passwordTextField.typeText("\n")
        
        let submitButton = buttons(identifier: .loginButton)
        submitButton.tap()
    }
    
    func testPasswordToggle() throws {
        let passwordTextField = securePasswordField
        XCTAssertNotNil(passwordTextField.isHittable)
        passwordTextField.tap()
        passwordTextField.typeText("password")
        
        toggleButton.tap()
        let showPasswordTextField = textField(identifier: .loginPasswordTextField)
        XCTAssertEqual(showPasswordTextField.value as! String, "password")
        
        toggleButton.tap()
        XCTAssertNotNil(passwordTextField.value)
    }
    
    func testAddList() throws {
        try testUserSignIn()
        
        let navBar = app.navigationBars["Wunderlist"]
        navBar.buttons["Add"].tap()
        
        
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        
    }

}
