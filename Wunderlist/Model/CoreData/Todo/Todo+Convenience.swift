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
        recurring: String,
        dueDate: Date,
        completed: Bool
    ) {
        // Noticed insert(into: EntityDescription, context) init - we might need to use this instead of directly assigning the user and initializing the context...
        
        //TODO: If we get weird crashes when making Todos, this might need to be user.managedObjectContext
        guard let context = user.managedObjectContext else { return nil }
        self.init(context: context)
        if !name.isEmpty && !recurring.isEmpty {
            self.name = name
            self.recurring = recurring
        } else {
            print("username or password were empty")
            return nil
        }
        self.user = user
        self.identifier = Int16(identifier)
        self.userId = Int16(identifier)
        self.dueDate = dueDate
        self.completed = completed


        print()
    }

    var todoRepresentation: TodoRepresentation? {
        guard let name = name,
            let recurring = recurring
        else { return nil }
        return TodoRepresentation(
            identifier: Int(identifier),
            completed: completed,
            name: name,
            recurring: recurring,
            userID: Int(userId)
        )
    }
}
