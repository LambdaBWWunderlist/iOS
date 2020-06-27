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
        let deleteOpExpectation = XCTestExpectation(description: "Wait for deleting old todos")

        authService.loginUser(with: "martianman", password: "password") { _ in
            let user = User(identifier: AuthService.activeUser!.identifier!, username: "martianman", email: "manfrom@mars.com")
            let todoDeleted7DaysAgo = Todo(user: user!, identifier: 404, name: "test", body: "body", recurring: Recurring.deleted, dueDate: Date(), completed: false, deletedDate: oldDate)

            let todoDeletedToday = Todo(user: user!, identifier: 405, name: "don't delete me", body: "body", recurring: Recurring.deleted, dueDate: Date(), completed: false, deletedDate: Date())

            XCTAssertEqual(todoDeleted7DaysAgo?.deletedDate, oldDate)

            try? CoreDataStack.shared.save()

            let firstTodoToDelete = FetchController().fetchTodosToDeleteFromActiveUser()
            
            XCTAssertEqual(firstTodoToDelete!.count, 1)
            let todoController = TodoController()


            todoController.delete7DayOldTodos() {
                let noTodosToDelete = FetchController().fetchTodosToDeleteFromActiveUser()
                XCTAssertEqual(noTodosToDelete?.count, 0)
                deleteOpExpectation.fulfill()
            }

            expectation.fulfill()
        }
        wait(for: [deleteOpExpectation], timeout: 5)
        wait(for: [expectation], timeout: 5)

    }

}
