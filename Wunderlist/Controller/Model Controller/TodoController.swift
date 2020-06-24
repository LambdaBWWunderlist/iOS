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
    let networkService = NetworkService()
    private let baseURL = URL(string: "https://wunderlist-node.herokuapp.com/api/items")!

    func syncTodosWithServer(identifiersOnServer: [Int], context: NSManagedObjectContext) {
        guard let identifier = AuthService.activeUser?.identifier else { return }
        let fetchRequest: NSFetchRequest<Todo> = Todo.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "creatorId == %@", identifier as CVarArg)
        //        //There's one in CoreData that isn't on the server.
        do {
            let existingTodos = try context.fetch(fetchRequest)
            for todo in existingTodos {
                if !identifiersOnServer.contains(Int(todo.identifier)) {
                    context.delete(todo)
                }
            }
        } catch {
            print("Error fetching all Todos in \(#function)")
        }
    }


    func getToDos(with completion: @escaping () -> Void) {
        guard var request = networkService.createRequest(url: baseURL, method: .post) else { return }
        guard let user = AuthService.activeUser else { return }
        request.setValue(user.token, forHTTPHeaderField: "Authorization")
        networkService.loadData(using: request) { (data, _, error) in
            if let error = error {
                print("\(error) Error retrieving data from server")
                completion()
                return
            }
            if let data = data {
                guard let representations = self.networkService.decode(to: [TodoRepresentation].self, data: data) else {
                    completion()
                    return
                }
                do{
                    try self.updateToDos(representations: representations)
                    completion()
                } catch {
                    print("\(error)")
                    completion()
                }
            }
        }
    }

    func postToDo(representation: TodoRepresentation, with completion: @escaping () -> Void) {
        guard var request = networkService.createRequest(url: baseURL, method: .post) else { return }
        guard let user = AuthService.activeUser else { return }
        request.setValue(user.token, forHTTPHeaderField: "Authorization")
        let encodingStatus = networkService.encode(from: representation, request: &request, dateFormatter: nil)
        guard let encodedRequest = encodingStatus.request else {
            completion()
            return
        }

        networkService.loadData(using: encodedRequest) { (data, response, error) in
            if let error = error {
                print("\(error) Error retrieving data from server")
                completion()
                return
            }
            guard data != nil else {
                print("data not retrieved from \(#file) \(#function) \(#line)")
                completion()
                return }
            guard let response = response as? HTTPURLResponse else {
                print("No Response?")
                completion()
                return
            }
            if response.statusCode != 201 {
                print("Bad Status Code \(response.statusCode)")
            }
        }

    }


    func updateToDo(representation: TodoRepresentation) {

    }

    func updateToDos(representations: [TodoRepresentation]) throws {
//        let identifiersToFetch = representations.compactMap {$0.identifier}
//        let representationsByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, representations))
//        var todosToCreate = representationsByID
//        let fetchRequest: NSFetchRequest<Todo> = Todo.fetchRequest()
//        fetchRequest.predicate = NSPredicate(format: "identifier IN %@", identifiersToFetch)
//        //            this might need to change ^ %a may be wrong placeholder
//        let context = CoreDataStack.shared.container.newBackgroundContext()
//        var error: Error?
//        if AuthService.activeUser != nil {
//            context.performAndWait {
//                do {
//                    let existingTodos = try context.fetch(fetchRequest)
//                    for todo in existingTodos {
//                        guard let identifier = todo.identifier,
//                            let representation = representationsByID[identifier] else { continue }
//                        self.updateTodoRep(todo, with: representation)
//                    }
//                } catch let fetchError {error = fetchError}
//            }
//            if let error = error {
//                throw error
//            }
//            for representation in todosToCreate.values {
//                Todo(todoRepresentation: representation, context: context, userRep: userRep )
//            }
//        }
    }

    private func updateTodoRep(todo: Todo, with representation: TodoRepresentation) {
        todo.name = representation.name
        todo.recurring = representation.recurring
        todo.completed = representation.completed
        todo.dueDate = representation.dueDate
    }


    func deleteToDoFromServer(representation: TodoRepresentation, with completion: @escaping () -> Void) {
//        let identifier = todo.identifier
//        let userId = AuthService.activeUser?.identifier?.uuidString ?? backupUserId
//        let requestURL = baseURL
//            .appendingPathComponent(userId)
//            .appendingPathComponent(uuid.uuidString)
//            .appendingPathExtension("json")
//
//        guard let request = networkService.createRequest(url: requestURL, method: .delete) else { return }
//        networkService.dataLoader.loadData(using: request) { _, _, error in
//            if let error = error {
//                NSLog("Error deleting entry from server \(todo): \(error)")
//                completion(.failure(.otherError))
//                return
//            }
//            completion(.success(true))
//    }
    }
}
