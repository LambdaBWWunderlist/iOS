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
        let preLoginUser = UserRepresentation(identifier: nil, username: "ironman", password: "iam!ronman")

        XCTAssertNotNil(request)

        let encodedRequest = networkService.encode(from: preLoginUser, request: &request!)

        XCTAssertNotNil(encodedRequest.request)
        XCTAssertNil(encodedRequest.error)

        networkService.dataLoader.loadData(using: request!) { (data, response, error) in
            XCTAssertNotNil(data)
            XCTAssertNotNil(response)
            let httpResponse = response as? HTTPURLResponse
            XCTAssertEqual(httpResponse?.statusCode, 200)
            XCTAssertNil(error)
            print(String(data: data!, encoding: .utf8))
            
            let decodedUser = networkService.decode(to: UserDetails.self, data: data!)
            XCTAssertNotNil(decodedUser)
            let loggedInUser = decodedUser!.user
            XCTAssertNotNil(loggedInUser)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

}
