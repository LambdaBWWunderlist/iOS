//
//  TodoController.swift
//  Wunderlist
//
//  Created by Kenny on 6/22/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import Foundation

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

        networkService.dataLoader.loadData(using: request) { data, _, error in
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
                to: [String: TodoRepresentation].self,
                data: data
                )
            let unwrappedReps = reps?.compactMap { $1 }
            completion(.success(true))
//            //update Todos
//            do {
//                //try self.updateTodos(with: unwrappedReps ?? [])
//                completion(.success(true))
//            } catch {
//                completion(.failure(.otherError))
//                NSLog("Error updating todos: \(error)")
//            }

        }
    }
}
