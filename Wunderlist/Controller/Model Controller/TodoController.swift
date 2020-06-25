//
//  TodoController.swift
//  Wunderlist
//
//  Created by Kenny on 6/22/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//
import Foundation
import CoreData

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
    private let baseURL = URL(string: "https://wunderlist-node.herokuapp.com/api/items")!
    private let networkService = NetworkService()

    // MARK: - Init -
    init() {
        if AuthService.activeUser != nil {
            fetchTodosFromServer()
        }
    }

    func fetchTodosFromServer(completion: @escaping CompletionHandler = { _ in } ) {
        let userURL = baseURL.appendingPathComponent("\(AuthService.activeUser?.identifier ?? 404)")
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
        let identifiersToFetch = representations.map {$0.identifier}
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

    private func updateTodoRep(todo: Todo, with representation: TodoRepresentation) {
        todo.name = representation.name
        todo.body = representation.body
        todo.recurring = representation.recurring
        todo.completed = representation.completed ?? false
        todo.dueDate = representation.dueDate
    }
    
//    func deleteToDoFromServer(representation: TodoRepresentation, with completion: @escaping () -> Void) {
//            let identifier = representation.identifier
//            let userId = AuthService.activeUser?.identifier?.uuidString ?? backupUserId
//            let requestURL = baseURL
//                .appendingPathComponent(userId)
//                .appendingPathComponent(uuid.uuidString)
//                .appendingPathExtension("json")
//        
//        guard let request = networkService.createRequest(url: requestURL, method: .delete) else { return }
//        networkService.dataLoader.loadData(using: request) { _, _, error in
//            if let error = error {
//                NSLog("Error deleting entry from server \(todo): \(error)")
//                completion(.failure(.otherError))
//                return
//            }
//            completion(.success(true))
//        }
//        
//    }
    
    func updateViews() {
        
    }
}
