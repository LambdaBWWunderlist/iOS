//
//  TodoController.swift
//  Wunderlist
//
//  Created by Kenny on 6/22/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//
import Foundation
import CoreData
import UIKit

class TodoController {
    let fetchController = FetchController()
    // Helper Properties
    enum NetworkError: Error {
        case noIdentifier
        case otherError
        case noData
        case noDecode
        case noEncode
        case noRep
    }

    typealias CompletionHandler = (Result<Bool, NetworkError>) -> Void
    var notificationController = NotificationController()
    private let baseURL = URL(string: "https://wunderlist-node.herokuapp.com/api/items")!
    private let networkService = NetworkService()

    // MARK: - Init -
    init() {
        if AuthService.activeUser != nil {
            fetchTodosFromServer()
        }
    }

    func fetchTodosFromServer(completion: @escaping CompletionHandler = { _ in } ) {

        guard let identifier = AuthService.activeUser?.identifier else {
            print("No active user")
            return
        }

        let userURL = baseURL.appendingPathComponent("\(identifier)")
        guard var request = networkService.createRequest(url: userURL, method: .get, headerType: .contentType, headerValue: .json) else {
            print("bad request")
            completion(.failure(.otherError))
            return
        }
        request.setValue(AuthService.activeUser?.token ?? "", forHTTPHeaderField: "Authorization")
        //send token to server, get back Todos for AuthService.activeUser
        networkService.dataLoader.loadData(using: request) { [weak self] (data, _, error) in
            guard let self = self else { return }

            if let error = error {
                NSLog("Error fetching todos: \(error)")
                completion(.failure(.otherError))
                return
            }

            guard let data = data else {
                NSLog("No data returned from request")
                completion(.failure(.noData))
                return
            }
            //decode representations
            let reps = self.networkService.decode(
                to: [TodoRepresentation].self,
                data: data,
                dateFormatter: self.networkService.dateFormatter
            )
            guard let unwrappedReps = reps else {
                print("error unwrapping representations")
                completion(.failure(.noRep))
                return
            }
            completion(.success(true))
            //update Todos
            do {
                try self.updateTodos(with: unwrappedReps)
                completion(.success(true))
            } catch {
                completion(.failure(.otherError))
                NSLog("Error updating todos: \(error)")
            }
        }
    }
    ///determine which representations need to be created and which need to be updated, and save the context
    func updateTodos(with representations: [TodoRepresentation]) throws {
        var identifiersToFetch: [Int] = []

        identifiersToFetch = representations.compactMap {
            if $0.recurring != .deleted {
                return $0.identifier
            }
            return nil
        }

        let representationsByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, representations))
        var todosToCreate = representationsByID
        let context = CoreDataStack.shared.container.newBackgroundContext()
        var error: Error?
        if AuthService.activeUser != nil {
            let fetchController = FetchController()

            guard let existingTodos = fetchController.fetchTodos(identifiersToFetch: identifiersToFetch, context: context) else {
                error = NSError(domain: "\(#file), \(#function), invoking fetchController", code: 400)
                throw error!
            }

            for todo in existingTodos {
                let identifier = Int(todo.identifier)
                guard let representation = representationsByID[identifier] else { continue }
                self.updateTodoRep(todo: todo, with: representation)
                todosToCreate.removeValue(forKey: identifier)
            }

            context.performAndWait {
                for representation in todosToCreate.values {
                    Todo(todoRepresentation: representation, context: context)
                }
                syncTodos(identifiersOnServer: identifiersToFetch, context: context)
                delete7DayOldTodos(context: context)
                do {
                    try CoreDataStack.shared.save(context: context)
                } catch let saveError {
                    print(saveError)
                }
            }
            if let error = error { throw error }
        }
    }

    func syncTodos(identifiersOnServer: [Int], context: NSManagedObjectContext) {

        guard let existingTodos = fetchController.fetchTodosFromActiveUser(context: context) else {
            print("Error fetching Todos from user")
            return
        }

        for todo in existingTodos {
            let todoId = Int(todo.identifier)
            if !identifiersOnServer.contains(todoId) {
                context.delete(todo)
            }
        }
    }

    func updateTodoRep(todo: Todo, with representation: TodoRepresentation) {
//        todo.name = representation.name
//        todo.body = representation.body
//        todo.recurring = representation.recurring?.rawValue
//        todo.completed = representation.completed ?? false
//        todo.dueDate = representation.dueDate
    }


    func updateTodoOnServer(todoRep: TodoRepresentation) {
        guard let identifier = todoRep.identifier else {
            print("nil todo identifier in \(#file) \(#function)")
            return
        }
        let todoURL = baseURL.appendingPathComponent("\(identifier)")
        var todoRep = todoRep
        //can't send the ID or the update fails on the backend
        todoRep.identifier = nil

        guard var request = networkService.createRequest(url: todoURL, method: .put, headerType: .contentType, headerValue: .json) else {
            print("request was nil in \(#file) \(#function)")
            return
        }
        guard let token = AuthService.activeUser?.token else {
            print("token was nil in \(#file) \(#function)")
            return
        }
        request.addValue(token, forHTTPHeaderField: NetworkService.HttpHeaderType.authorization.rawValue)

        guard let encodedTodoRepRequest = networkService.encode(from: todoRep, request: &request, dateFormatter: networkService.dateFormatter).request else {
            print("Error creating request in \(#file), \(#function)")
            return
        }

        networkService.loadData(using: encodedTodoRepRequest) { (data, _, error) in
            if let error = error {
                print("\(#file), \(#function) - Error updating Todo: \(error)")
            }
            guard let data = data else { return }
            print(String(data: data, encoding: .utf8) as Any)
        }
    }

    func createTodo(representation: TodoRepresentation, date: Date, complete: @escaping ()-> Void) {
        createTodoOnServer(representation: representation) { identifier in

            guard let identifier = identifier else { return }
            var rep = representation
            rep.identifier = identifier
            guard var todoRep = self.fetchController.fetchTodo(todoRep: rep)?.todoRepresentation else { return }
            todoRep.identifier = identifier
            switch todoRep.recurring {
            case .daily:
                self.notificationController.triggerNotification(todoRep: todoRep, notificationType: .reminderDaily, onDate: date)
            case .weekly:
                self.notificationController.triggerNotification(todoRep: todoRep, notificationType: .reminderWeekly, onDate: date)
            case .monthly:
                self.notificationController.triggerNotification(todoRep: todoRep, notificationType: .reminderMonthly, onDate: date)
            case nil:
                self.notificationController.triggerNotification(todoRep: todoRep, notificationType: .reminderOneTime, onDate: date)
            case .deleted:
                return
            }
        complete()
        }
    }

    private func createTodoOnServer(representation: TodoRepresentation, complete: @escaping (Int?) -> Void) {
        guard var request = networkService.createRequest(url: baseURL, method: .post, headerType: .contentType, headerValue: .json) else {

            print("Error creating request in \(#file), \(#function). invalid URL?")
            complete(nil)
            return
        }
        guard var requestWithEncodedRep = networkService.encode(from: representation, request: &request, dateFormatter: networkService.dateFormatter).request else {
            print("Error encoding representation in \(#file), \(#function). Check the logs")
            complete(nil)
            return
        }
        guard let token = AuthService.activeUser?.token else {
            print("No active user in \(#file), \(#function)")
            complete(nil)
            return
        }

        requestWithEncodedRep.addValue(token, forHTTPHeaderField: NetworkService.HttpHeaderType.authorization.rawValue)

        networkService.loadData(using: requestWithEncodedRep) { [weak self] (data, response, _) in
            guard let self = self else { return }

            if let response = response as? HTTPURLResponse {
                if response.statusCode == 201 {
                    guard let data = data,
                        let returnedRepresentation = self.networkService.decode(to: TodoRepresentation.self, data: data, dateFormatter: self.networkService.dateFormatter)
                        else {
                            print("data was nil or returnedRepresentation couldn't be decoded in \(#file), \(#function)")
                            complete(nil)
                            return
                    }

                    self.createTodoInCoreData(representation: returnedRepresentation) {
                        complete(returnedRepresentation.identifier)
                    }
                    print("\(String(describing: returnedRepresentation.userID)) \(String(describing: returnedRepresentation.identifier)) \(String(describing: returnedRepresentation.recurring))")
                } else {
                    print("bad status code in \(#file), \(#function): \(response.statusCode)")
                    complete(nil)
                    return
                }
            }

        }

    }

    private func createTodoInCoreData(representation: TodoRepresentation, complete: @escaping () -> ()) {
        let context = CoreDataStack.shared.container.newBackgroundContext()
        Todo(todoRepresentation: representation, context: context)
        context.perform {
            do {
                try context.save()

                } catch {
                print("Error saving Todo in \(#file) \(#function): \(error)")
            }
            complete()
        }
    }

    func deleteTodo(representation: TodoRepresentation) {
        deleteToDoFromServer(representation: representation) { [weak self] in
            guard let self = self else { return }
            self.deleteTodoFromCoreData(representation: representation)
        }
    }

    private func deleteToDoFromServer(representation: TodoRepresentation, with completion: @escaping () -> Void) {
        guard let identifier = representation.identifier else {
            print("identifier was nil")
            completion()
            return
        }
        let requestURL = baseURL
            .appendingPathComponent("\(identifier)")

        guard var request = networkService.createRequest(url: requestURL, method: .delete) else {
            print("the request failed. Is the URL valid?")
            completion()
            return
        }
        guard let token = AuthService.activeUser?.token else { return }
        request.addValue(token, forHTTPHeaderField: NetworkService.HttpHeaderType.authorization.rawValue)
        networkService.dataLoader.loadData(using: request) { _, _, error in
            if let error = error {
                print("Error deleting todo from server: \(error)")
                completion()
                return
            }

            completion()
        }
    }

    private func deleteTodoFromCoreData(representation: TodoRepresentation) {
        guard let todo = fetchController.fetchTodo(todoRep: representation) else {
            print("fetching todo failed. can't delete it")
            return
        }
        let context = CoreDataStack.shared.mainContext
        if todo.recurring == "deleted" {
            context.performAndWait {
                context.delete(todo)
            }
        } else {
            todo.recurring = "deleted"
        }

        do {
            try CoreDataStack.shared.save(context: context)
        } catch let saveError {
            print("Error saving context: \(saveError)")
        }
    }

    func delete7DayOldTodos(context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        guard let oldTodos = fetchController.fetchTodosToDeleteFromActiveUser(context: context) else {
            print("failed to fetch oldTodos. no old todos?")
            return
        }

        do {
            for todo in oldTodos {
                context.delete(todo)
            }
        }
    }

}
