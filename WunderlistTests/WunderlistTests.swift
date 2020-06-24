//
//  WunderlistTests.swift
//  WunderlistTests
//
//  Created by Kenny on 6/21/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import XCTest
@testable import Wunderlist

class WunderlistTests: XCTestCase {

    func testDecodingMockLoginUser() {
        let expectation = self.expectation(description: "\(#file), \(#function): WaitForDecodingMockUserData")

        let mockDataLoader = MockDataLoader(
            data: Data.mockData(with: .goodLoginUserData),
            response: nil,
            error: nil
        )

        let networkService = NetworkService(dataLoader: mockDataLoader)
        let request = networkService.createRequest(url: URL(string: "https://www.google.com"), method: .get)

        XCTAssertNotNil(request)

        networkService.dataLoader.loadData(using: request!) { (data, response, error) in
            XCTAssertNotNil(data)
            XCTAssertNil(response)
            XCTAssertNil(error)
            let mockUser = networkService.decode(to: UserRepresentation.self, data: data!)
            XCTAssertNotNil(mockUser)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    func testDecodingLiveLoginUser() {
        let expectation = self.expectation(description: "\(#file), \(#function): WaitForDecodingLiveUserData")

            let authService = AuthService()
        authService.loginUser(
            with: AuthService.ironMan.username,
            password: AuthService.ironMan.password!
        ) {
            XCTAssertNotNil(AuthService.activeUser)
            XCTAssertNotNil(AuthService.activeUser?.token)
            expectation.fulfill()
        }
        /*
         This timeout is so long because the server sleeps sometimes.
         It sleeps when nobody has logged in for a period of time
         So the test doesn't normally take 30 seconds
         */
        wait(for: [expectation], timeout: 30.0)
    }

    func testFetchingTodos() {
        let authService = AuthService()
        let authExpectation = self.expectation(description: "\(#file), \(#function): WaitForLoggingIn")
        authService.loginUser(with: AuthService.ironMan.username, password: AuthService.ironMan.password!) {
            authExpectation.fulfill()
        }
        wait(for: [authExpectation], timeout: 5.0)
        let expectation = self.expectation(description: "\(#file), \(#function): WaitForFetchingTodos")

        let todoController = TodoController()
        todoController.fetchTodosFromServer() { _ in
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    /*
     Standard Deviation is *much* higher than it should be for this test
     Heroku may do something when the server spins up that takes a bit longer
     ... and it's still only half a second on the first login
    */
    func testSpeedOfTypicalLoginRequest() {
        measureMetrics([.wallClockTime], automaticallyStartMeasuring: false) {
            let expectation = self.expectation(description: "\(#file), \(#function): WaitForLoginSpeedResult")
            let controller = AuthService(dataLoader: URLSession(configuration: .ephemeral))
            startMeasuring()
            let ironMan = AuthService.ironMan
            controller.loginUser(with: ironMan.username, password: ironMan.password!) {
                XCTAssertNotNil(AuthService.activeUser)
                expectation.fulfill()
            }
            wait(for: [expectation], timeout: 5)
        }
    }

}
