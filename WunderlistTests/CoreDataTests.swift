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
        let todo = Todo(user: user!, identifier: 2, name: "do", body: "body", recurring: Recurring.daily, dueDate: Date(), completed: false)
        let todo2 = Todo(user: user!, identifier: 3, name: "dont", body: "body", recurring: nil, dueDate: Date(), completed: false)

        XCTAssertNotNil(todo?.user)
        XCTAssertNotNil(todo?.identifier)
        XCTAssertNotNil(todo?.name)
        XCTAssertNotNil(todo?.recurring)
        XCTAssertNil(todo2?.recurring)

        XCTAssertEqual(user?.todos?.count, 2)

        XCTAssertEqual(todo?.user, user)
        XCTAssertEqual(todo2?.user, user)
    }

    func testDeletingOldTodo() {
        let oldDate = Date() - 8*24*60*60
        let authService = AuthService()
        let expectation = self.expectation(description: "WaitForLoginWhileDeletingOldTodo")

        authService.loginUser(with: "testiOSUser3", password: "Secret") {
            let user = User(identifier: 13, username: "testiOSUser3", email: "iosUser3@apple.com")
            let todo = Todo(user: user!, identifier: 2, name: "test", body: "body", recurring: Recurring.daily, dueDate: Date(), completed: false, deletedDate: oldDate)
            XCTAssertEqual(todo?.deletedDate, oldDate)

            try? CoreDataStack.shared.save()

            let firstTodosToDelete = FetchController().fetchTodosToDeleteFromActiveUser()
            
            XCTAssertGreaterThanOrEqual(firstTodosToDelete!.count, 1)
            let todoController = TodoController()
            todoController.delete7DayOldTodos()

            let noTodosToDelete = FetchController().fetchTodosToDeleteFromActiveUser()
            XCTAssertEqual(noTodosToDelete?.count, 0)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)

    }

}
