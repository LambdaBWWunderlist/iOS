//
//  User+Convenience.swift
//  Wunderlist
//
//  Created by Kenny on 6/21/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import CoreData

extension User {
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

    var userRepresentation: UserRepresentation? {
        guard let username = username else { return nil }
        return UserRepresentation(id: Int(self.identifier), username: username, password: nil, email: self.email, token: nil)
    }
}
