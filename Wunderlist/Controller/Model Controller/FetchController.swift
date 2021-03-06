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
        guard let username = AuthService.activeUser?.username else {
            print("Error: No identifier from active User in \(#function)")
            return nil
        }
        let predicate = NSPredicate(format: "username == %@ AND identifier IN %@", username, identifiersToFetch)
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
        guard let username = AuthService.activeUser?.username else {
            print("Error: No identifier from active User in \(#function)")
            return nil
        }

        let todoFetchRequest: NSFetchRequest<Todo> = Todo.fetchRequest()
        guard let identifier = todoRep.identifier else { return nil }
        let predicate = NSPredicate(format: "username == %@ AND identifier == %d", username, identifier )
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
            print("Error: No identifier from active User in \(#function)")
            return nil
        }
        let fetchRequest: NSFetchRequest<Todo> = Todo.fetchRequest()
        let deleted = Recurring.deleted.rawValue
        fetchRequest.predicate = NSPredicate(format: "username == %@ AND recurring != %@", identifier as CVarArg, deleted)
        do {
            let todos = try context.fetch(fetchRequest)
            return todos
        } catch {
            print("Error retrieving todo: \(error)")
            return nil
        }
    }

    func fetchTodosToDeleteFromActiveUser(context: NSManagedObjectContext = CoreDataStack.shared.mainContext) -> [Todo]? {
        guard let username = AuthService.activeUser?.username else {
            print("Error: No identifier from active User in \(#function)")
            return nil
        }
        let maxDeletedDate = Date().addingTimeInterval(-7*24*60*60) //days, hours, minutes, seconds
        let fetchRequest: NSFetchRequest<Todo> = Todo.fetchRequest()

        fetchRequest.predicate = NSPredicate(format: "username == %@ AND deletedDate <= %@", username, maxDeletedDate as CVarArg)
        do {
            let todos = try context.fetch(fetchRequest)
            return todos
        } catch {
            print("Error retrieving todo: \(error)")
            return nil
        }
    }

}
