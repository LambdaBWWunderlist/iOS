//
//  CoreDataTests.swift
//  WunderlistTests
//
//  Created by Kenny on 6/22/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import XCTest
@testable import Wunderlist

class CoreDataTests: XCTestCase {

    func testUserTodoRelationship() {
        let user = User(identifier: 1, username: "kenny", email: "kennydubroff@hotmail.com")
        let todo = Todo(user: user!, identifier: 2, name: "do", recurring: "yeah", dueDate: Date(), completed: false)
        let todo2 = Todo(user: user!, identifier: 3, name: "dont", recurring: "nah", dueDate: Date(), completed: false)

        XCTAssertNotNil(todo?.user)
        XCTAssertNotNil(todo?.identifier)
        XCTAssertNotNil(todo?.name)
        XCTAssertNotNil(todo?.recurring)

        XCTAssertEqual(user?.todos?.count, 2)

        XCTAssertEqual(todo?.user, user)
        XCTAssertEqual(todo2?.user, user)
    }

}
