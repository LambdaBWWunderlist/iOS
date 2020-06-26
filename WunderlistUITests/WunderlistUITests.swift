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
//        case searchBar = "SearchBar"
    }
    
    private var testUsername = "mockUser"
    private var testEmail = "mock@email.com"
    private var testPassword = "password"
    private var testTitle = "Title"
    private var testBody = "Body"
    
    private var app: XCUIApplication {
        return XCUIApplication()
    }
    
//    private func searchField(identifier: Identifier) -> XCUIElement {
//        return app.searchFields[identifier.rawValue]
//    }
    
    
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
    
//    private var searchBar: XCUIElement {
//        return searchField(identifier: .searchBar)
//    }
    
    
    private func signInHelper() {
        let logInButton = app.segmentedControls.buttons["Log In"]
        XCTAssert(logInButton.isHittable)
        logInButton.tap()
        
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
        signInHelper()
        
        let navBar = app.navigationBars["Wunderlist"]
        navBar.buttons["Add"].tap()
        
        let titleTextField = textField(identifier: .createTitleLabel)
        titleTextField.tap()
        titleTextField.typeText("New Entry")
        XCTAssertEqual(titleTextField.value as! String, "New Entry")
        enterButton.tap()
        
        let recurButton = app.segmentedControls.buttons["Weekly"]
        recurButton.tap()
        
        let datePickers = XCUIApplication().datePickers
        datePickers.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "Jun 24")
        datePickers.pickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: "9")
        datePickers.pickerWheels.element(boundBy: 2).adjust(toPickerWheelValue: "02")
        datePickers.pickerWheels.element(boundBy: 3).adjust(toPickerWheelValue: "PM")
        
        let bodyTextView = textView(identifier: .createBodyTextView)
        bodyTextView.tap()
        bodyTextView.typeText("Body Here")
        XCTAssertEqual(bodyTextView.value as! String, "Body Here")
        
        let createNavBar = app.navigationBars["Create a List"]
        createNavBar.buttons["Save"].tap()
    }
    
    func testSearchBar() throws {
        try testUserSignIn()
        
        let navBar = app.navigationBars["Wunderlist"]
        XCTAssertNotNil(navBar)
        
        let cell = app.tables.staticTexts["New Entry"]
        XCTAssertNotNil(cell)
        
        let tablesQuery = app.tables
        
        let searchField = tablesQuery.children(matching: .other).element(boundBy: 1).children(matching: .searchField).element
        searchField.tap()
        XCTAssert(searchField.isHittable)
        
        searchField.typeText("Apple")
        XCTAssert(tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["an apple a day"]/*[[".cells[\"an apple a day\"]",".staticTexts[\"an apple a day\"]",".staticTexts[\"TodoTableViewCell.titleLabel\"]",".cells[\"ToDoListTVC.todoCell\"]"],[[[-1,2],[-1,1],[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[1]]@END_MENU_TOKEN@*/.exists)
        XCTAssert(!tablesQuery.staticTexts["New Entry"].exists)
        
        let searchButton = app/*@START_MENU_TOKEN@*/.buttons["Search"]/*[[".keyboards",".buttons[\"search\"]",".buttons[\"Search\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/
        searchButton.tap()
        
        let clearTextButton = tablesQuery.buttons["Clear text"]
        clearTextButton.tap()
        
        XCTAssert(tablesQuery.staticTexts["an apple a day"].exists)
        XCTAssert(tablesQuery.staticTexts["New Entry"].exists)
    }
    
    func testFunction() {
        
        
        let app = XCUIApplication()
        app/*@START_MENU_TOKEN@*/.buttons["Log In"]/*[[".segmentedControls.buttons[\"Log In\"]",".buttons[\"Log In\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.textFields["LoginViewController.usernameTextField"]/*[[".textFields[\"Username\"]",".textFields[\"LoginViewController.usernameTextField\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.buttons["shift"]/*[[".keyboards.buttons[\"shift\"]",".buttons[\"shift\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let uKey = app/*@START_MENU_TOKEN@*/.keys["U"]/*[[".keyboards.keys[\"U\"]",".keys[\"U\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        uKey.tap()
        uKey.tap()
        
        let sKey = app/*@START_MENU_TOKEN@*/.keys["s"]/*[[".keyboards.keys[\"s\"]",".keys[\"s\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        sKey.tap()
        
        let eKey = app/*@START_MENU_TOKEN@*/.keys["e"]/*[[".keyboards.keys[\"e\"]",".keys[\"e\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        eKey.tap()
        
        let rKey = app/*@START_MENU_TOKEN@*/.keys["r"]/*[[".keyboards.keys[\"r\"]",".keys[\"r\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        rKey.tap()
        app/*@START_MENU_TOKEN@*/.secureTextFields["LoginViewController.passwordTextField"]/*[[".secureTextFields[\"Password\"]",".secureTextFields[\"LoginViewController.passwordTextField\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.keys["p"]/*[[".keyboards.keys[\"p\"]",".keys[\"p\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let aKey = app/*@START_MENU_TOKEN@*/.keys["a"]/*[[".keyboards.keys[\"a\"]",".keys[\"a\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        aKey.tap()
        sKey.tap()
        sKey.tap()
        sKey.tap()
        
        let wKey = app/*@START_MENU_TOKEN@*/.keys["w"]/*[[".keyboards.keys[\"w\"]",".keys[\"w\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        wKey.tap()
        wKey.tap()
        app/*@START_MENU_TOKEN@*/.keys["o"]/*[[".keyboards.keys[\"o\"]",".keys[\"o\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        rKey.tap()
        
        let dKey = app/*@START_MENU_TOKEN@*/.keys["d"]/*[[".keyboards.keys[\"d\"]",".keys[\"d\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        dKey.tap()
        dKey.tap()
        app.buttons["LoginViewController.loginButton"].tap()
        
        let tablesQuery = app.tables
        tablesQuery.children(matching: .other).element(boundBy: 1).children(matching: .searchField).element.tap()
        app/*@START_MENU_TOKEN@*/.keys["D"]/*[[".keyboards.keys[\"D\"]",".keys[\"D\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        aKey.tap()
        aKey.tap()
        app/*@START_MENU_TOKEN@*/.keys["i"]/*[[".keyboards.keys[\"i\"]",".keys[\"i\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let lKey = app/*@START_MENU_TOKEN@*/.keys["l"]/*[[".keyboards.keys[\"l\"]",".keys[\"l\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        lKey.tap()
        lKey.tap()
        
        let yKey = app/*@START_MENU_TOKEN@*/.keys["y"]/*[[".keyboards.keys[\"y\"]",".keys[\"y\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        yKey.tap()
        yKey.tap()
        
        let searchButton = app/*@START_MENU_TOKEN@*/.buttons["Search"]/*[[".keyboards",".buttons[\"search\"]",".buttons[\"Search\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/
        searchButton.tap()
        
        let clearTextButton = tablesQuery.buttons["Clear text"]
        clearTextButton.tap()
        app/*@START_MENU_TOKEN@*/.keys["W"]/*[[".keyboards.keys[\"W\"]",".keys[\"W\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        eKey.tap()
        eKey.tap()
        eKey.tap()
        app/*@START_MENU_TOKEN@*/.keys["k"]/*[[".keyboards.keys[\"k\"]",".keys[\"k\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        lKey.tap()
        yKey.tap()
        yKey.tap()
        clearTextButton.tap()
        
        let eKey2 = app/*@START_MENU_TOKEN@*/.keys["E"]/*[[".keyboards.keys[\"E\"]",".keys[\"E\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        eKey2.tap()
        eKey2.tap()
        app/*@START_MENU_TOKEN@*/.keys["n"]/*[[".keyboards.keys[\"n\"]",".keys[\"n\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.keys["t"]/*[[".keyboards.keys[\"t\"]",".keys[\"t\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        rKey.tap()
        rKey.tap()
        yKey.tap()
        yKey.tap()
        searchButton.tap()
        tablesQuery.buttons["Cancel"].tap()
       
        
        
        
    }
}
