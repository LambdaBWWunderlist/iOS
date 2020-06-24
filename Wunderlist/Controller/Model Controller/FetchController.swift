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

    func fetchTodos(identifiersToFetch: [Int], context: NSManagedObjectContext = CoreDataStack.shared.mainContext) -> [Todo]? {
        let fetchRequest: NSFetchRequest<Todo> = Todo.fetchRequest()
        let predicate = NSPredicate(format: "identifier IN %@", identifiersToFetch)
        fetchRequest.predicate = predicate
        do {
            let todos = try context.fetch(fetchRequest)
            return todos
        }catch {
            print("Error Fetching Todos")
            return nil
        }
    }

    func fetchTodo(todoRep: TodoRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) -> Todo? {
        let todoFetchRequest: NSFetchRequest<Todo> = Todo.fetchRequest()
        let predicate = NSPredicate(format: "identifier == %d", todoRep.identifier )
        todoFetchRequest.predicate = predicate
        print(predicate)
        do {
            guard let todo = try context.fetch(todoFetchRequest).first else {
                print("Predicate: \(predicate) failed to fetch object")
                return nil
            }
            return todo
        } catch {
            print("Error fetching Todo from CoreData")
        }

        return nil
    }

    func fetchUser(userRep: UserRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) -> User? {
        guard let identifier = userRep.identifier else { return nil }
        let userFetchRequest: NSFetchRequest<User> = User.fetchRequest()
        userFetchRequest.predicate = NSPredicate(format: "identifier == %d", identifier)

        do {
            guard let user = try context.fetch(userFetchRequest).first else { return nil }
            return user
        } catch {
            print("Error fetching User from CoreData")
            return nil
        }
    }

    func fetchTodosFromActiveUser(context: NSManagedObjectContext = CoreDataStack.shared.mainContext) -> [Todo]? {
        guard let identifier = AuthService.activeUser?.username else {
            print("Error: No identifier from active User")
            return nil
        }
        let fetchRequest: NSFetchRequest<Todo> = Todo.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "username == %@", identifier as CVarArg)

        do {
            let todos = try context.fetch(fetchRequest)
            return todos
        } catch {
            print("Error retrieving todo: \(error)")
            return nil
        }
    }

}
