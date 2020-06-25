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
        recurring: String,
        dueDate: Date,
        completed: Bool
    ) {
        // Noticed insert(into: EntityDescription, context) init - we might need to use this instead of directly assigning the user and initializing the context...

        //TODO: If we get weird crashes when making Todos, this might need to be user.managedObjectContext
        guard let context = user.managedObjectContext else { return nil }
        self.init(context: context)
        if !name.isEmpty && !recurring.isEmpty {
            self.user = user
            self.identifier = Int16(identifier)
            self.name = name
            self.body = body
            self.recurring = recurring
            self.completed = completed
            self.username = user.username
            self.dueDate = dueDate
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
                  recurring: todoRepresentation.recurring ?? "daily",
                  dueDate: todoRepresentation.dueDate ?? Date(),
                  completed: todoRepresentation.completed ?? false)
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
            recurring: recurring,
            username: username,
            dueDate: dueDate
        )
    }
}
