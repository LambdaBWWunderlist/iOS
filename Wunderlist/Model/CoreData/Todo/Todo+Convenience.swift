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
        username: String,
        email: String,
        context: NSManagedObjectContext = CoreDataStack.shared.mainContext
    ) {
        self.init(context: context)
        self.identifier = Int16(identifier)
        if !username.isEmpty && !email.isEmpty {
            self.username = username
            self.email = email
        } else {
            print("username or password were empty")
            return nil
        }
    }
}
