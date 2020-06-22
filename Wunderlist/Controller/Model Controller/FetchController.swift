//
//  FetchController.swift
//  Wunderlist
//
//  Created by Kenny on 6/22/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import Foundation
import CoreData

class FetchController {

//    func fetchTodo(todoRep: TodoRepresentation) {
//        let todoFetchRequest: NSFetchRequest<Todo> = Todo.fetchRequest()
//
//    }

    func fetchUser(userRep: UserRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) -> User? {
        let userFetchRequest: NSFetchRequest<User> = User.fetchRequest()
        userFetchRequest.predicate = NSPredicate(format: "identifier == %@", userRep.identifier)
        do {
            guard let user = try context.fetch(userFetchRequest).first else { return nil }
            return user
        } catch {
            print("Error fetching User from CoreData")
        }
        return nil
    }
}
