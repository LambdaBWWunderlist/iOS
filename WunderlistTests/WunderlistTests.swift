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

        let networkService = NetworkService()
        var request = networkService.createRequest(url: URL(string: "https://wunderlist-node.herokuapp.com/api/login"), method: .post, headerType: .contentType, headerValue: .json)
        let preLoginUser = AuthService.ironMan

        XCTAssertNotNil(request)

        let encodingStatus = networkService.encode(from: preLoginUser, request: &request!)

        XCTAssertNil(encodingStatus.error)
        XCTAssertNotNil(encodingStatus.request)


        networkService.dataLoader.loadData(using: request!) { (data, response, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(data)
            XCTAssertNotNil(response)

            let httpResponse = response as? HTTPURLResponse
            XCTAssertEqual(httpResponse?.statusCode, 200)

            print(String(data: data!, encoding: .utf8) as Any) //as Any to silence warning
            
            let decodedUser = networkService.decode(to: UserDetails.self, data: data!)
            XCTAssertNotNil(decodedUser)

            var loggedInUser = decodedUser!.user
            loggedInUser.token = decodedUser!.token
            XCTAssertNotNil(loggedInUser)
            XCTAssertNotNil(loggedInUser.token)

            expectation.fulfill()
        }
        /*
         This timeout is so long because the server sleeps sometimes.
         It sleeps when nobody has logged in for a period of time
         So the test doesn't normally take 30 seconds
         */
        wait(for: [expectation], timeout: 30.0)
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
