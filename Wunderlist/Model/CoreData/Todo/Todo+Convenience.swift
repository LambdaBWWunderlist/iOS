//
//  Todo+Convenience.swift
//  Wunderlist
//
//  Created by Kenny on 6/21/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import CoreData

extension Todo {
    @discardableResult convenience init?(
        user: User,
        identifier: Int,
        name: String,
        body: String?,
        recurring: Recurring?,
        dueDate: Date,
        completed: Bool,
        deletedDate: Date? = nil
    ) {

        guard let context = user.managedObjectContext else { return nil }
        self.init(context: context)
        if !name.isEmpty {
            self.user = user
            self.identifier = Int16(identifier)
            self.name = name
            self.body = body
            self.recurring = recurring?.rawValue
            self.completed = completed
            self.username = user.username
            self.dueDate = dueDate
            self.deletedDate = deletedDate
        } else {
            print("recurring, username or password were empty")
            return nil
        }
        print()
    }

    @discardableResult convenience init?(todoRepresentation: TodoRepresentation, context: NSManagedObjectContext) {
        let fetchController = FetchController()
        guard let userRep = AuthService.activeUser,
            let user = fetchController.fetchUser(userRep: userRep, context: context),
            let identifier = todoRepresentation.identifier else {
                print("userRep or fetchedUser were nil")
                return nil
        }
        self.init(user: user,
                  identifier: identifier,
                  name: todoRepresentation.name,
                  body: todoRepresentation.body,
                  recurring: todoRepresentation.recurring,
                  dueDate: todoRepresentation.dueDate ?? Date(),
                  completed: todoRepresentation.completed ?? false,
                  deletedDate: todoRepresentation.deletedDate
        )
    }

    var todoRepresentation: TodoRepresentation? {
        guard let name = name,
//            let recurring = recurring,
//            let date = dueDate,
            let username = username
        else { return nil }
        return TodoRepresentation(
            identifier: Int(identifier),
            completed: completed,
            name: name,
            body: body,
            recurring: Recurring(rawValue: recurring ?? ""), //this will be nil if it fails, and that's fine
            username: username,
            userID: Int(user?.identifier ?? 0),
            dueDate: dueDate,
            deletedDate: deletedDate
        )
    }
}
