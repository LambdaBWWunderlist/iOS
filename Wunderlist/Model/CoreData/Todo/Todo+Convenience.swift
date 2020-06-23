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
        identifier: Int,
        name: String,
        recurring: String,
        completed: Bool,
        user: User
    ) {
        // Noticed insert(into: EntityDescription, context) init - we might need to use this instead of directly assigning the user and initializing the context...
        
        //TODO: If we get weird crashes when making Todos, this might need to be user.managedObjectContext
        guard let context = user.managedObjectContext else { return nil }
        self.init(context: context)

        self.user = user
        self.identifier = Int16(identifier)
        self.user_id = Int16(identifier)
        self.completed = completed

        if !name.isEmpty && !recurring.isEmpty {
            self.name = name
            self.recurring = recurring
        } else {
            print("username or password were empty")
            return nil
        }
        print()
    }

    var todoRepresentation: TodoRepresentation? {
        guard let name = name,
            let recurring = recurring
        else { return nil }
        return TodoRepresentation(
            identifier: Int(self.identifier),
            completed: self.completed,
            name: name,
            recurring: recurring,
            user_id: Int(self.user_id)
        )
    }
}
