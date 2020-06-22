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
        user: UserRepresentation,
        context: NSManagedObjectContext = CoreDataStack.shared.mainContext
    ) {
        //TODO: If we get weird crashes when making Todos, this might need to be user.managedObjectContext
        self.init(context: context)
        self.identifier = Int16(identifier)
        if !name.isEmpty && !recurring.isEmpty {
            self.name = name
            self.recurring = recurring
        } else {
            print("username or password were empty")
            return nil
        }
        let fetchController = FetchController()
        self.user = fetchController.fetchUser(userRep: user, context: context)
        self.user_id = Int16(user.identifier)
    }

    
}
