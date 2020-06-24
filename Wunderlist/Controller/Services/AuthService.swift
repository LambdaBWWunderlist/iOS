//
//  AuthService.swift
//  Wunderlist
//
//  Created by Kenny on 6/22/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//
import Foundation

class AuthService {
    // MARK: - Properties -
    private let networkService = NetworkService()
    private let dataLoader: NetworkLoader
    private let baseURL = URL(string: "https://wunderlist-node.herokuapp.com/api/")!

    ///The currently logged in user
    ///
    /// Static so it's always accessible and always the same user (until another user is logged in)
    static var activeUser: UserRepresentation?

    /// Seeded user on backend (great for testing)
    static let ironMan = UserRepresentation(identifier: nil, username: "ironman", password: "iam!ronman", email: "ironman@ironman.com")

    static let testUser = UserRepresentation(identifier: nil, username: "ThomTest", password: "Secret", email: "thehammersvpa@gmail.com") //id 7

    static let testUser4 = UserRepresentation(identifier: nil, username: "testiOSUser4", password: "Secret", email: "iosUser4@apple.com") //id 13

    // MARK: - Init -
    init(dataLoader: NetworkLoader = URLSession.shared) {
        self.dataLoader = dataLoader
    }

    // MARK: - Methods -

    /// Register a User on the Heroku API
    /// - Parameters:
    ///   - username: Minimum 4 characters
    ///   - password: Minimum 6 characters
    ///   - completion: Signals when the method is complete (returns nothing)
    func registerUser(username: String,
                      password: String,
                      email: String,
                      completion: @escaping () -> Void) {
        let requestURL = baseURL.appendingPathComponent("register")

        guard var request = networkService.createRequest(
            url: requestURL,
            method: .post,
            headerType: .contentType,
            headerValue: .json
            ) else { return }

        var registerUser = UserRepresentation(identifier: nil, username: username, password: password, email: email)
        let encodedUser = networkService.encode(from: registerUser, request: &request)

        guard let requestWithUser = encodedUser.request else {
            print("requestWithUser failed, error encoding user?")
            completion()
            return
        }

        networkService.dataLoader.loadData(using: requestWithUser, with: { (data, response, error) in
            if let error = error {
                print("error registering user: \(error)")
                completion()
                return
            }
            if let response = response as? HTTPURLResponse {
                print("registration response status code: \(response.statusCode)")
            }
            if let data = data {
                print(String(data: data, encoding: .utf8) as Any) //as Any to silence warning
                guard let returnedUserDetails = self.networkService.decode(
                    to: UserRepresentation.self,
                    data: data
                    ) else { return }
                registerUser = returnedUserDetails
                guard let identifier = registerUser.identifier,
                    let email = registerUser.email
                    else {
                        print("unable to retrieve email or identifier from registered user")
                        return
                }

                //save user
                User(identifier: identifier, username: registerUser.username, email: email)
                do {
                    try CoreDataStack.shared.save()
                    AuthService.activeUser = registerUser
                } catch let saveError {
                    print("Error saving user: \(saveError)")
                    completion()
                    return
                }
            }
            completion()
        })
    }

    /// Login to the heroku API
    /// - Parameters:
    ///   - username: The registered user's username
    ///   - password: The registered user's
    ///   - completion: Signals when the method is complete (returns nothing)
    func loginUser(with username: String,
                   password: String,
                   completion: @escaping () -> Void) {
        let loginURL = baseURL.appendingPathComponent("login")
        guard var request = networkService.createRequest(
            url: loginURL,
            method: .post,
            headerType: .contentType,
            headerValue: .json
            ) else {
                print("Error forming request, bad URL?")
                completion()
                return
        }
        //create a user to be encoded and sent to the server for login
        let preLoginUser = UserRepresentation(identifier: nil, username: username, password: password)
        let encodingStatus = networkService.encode(from: preLoginUser, request: &request)
        guard let requestWithUser = encodingStatus.request else {
            print("requestWithUser failed, error encoding user?")
            completion()
            return
        }
        networkService.dataLoader.loadData(using: requestWithUser) { (data, response, error) in
            if let error = error {
                NSLog("Error logging user in: \(error)")
                completion()
                return
            }
            guard let data = data else {
                print("No data from login request")
                completion()
                return
            }
            if let response = response as? HTTPURLResponse {
                print(response.statusCode)
                if response.statusCode == 200 {
                    //this assigns all of the user's attributes from the server since the server is
                    //returning username, token, and identifier, but password is nil which is perfect
                    //for security purposes (and we dont need password after this)
                    guard var loggedIn = self.networkService.decode(
                        to: UserDetails.self,
                        data: data
                        ) else { return }
                    //assign the static activeUser
                    loggedIn.user.token = loggedIn.token
                    AuthService.activeUser = loggedIn.user

                    //check for existing CoreData user and save if one doesn't exist (user logged in to a new device, etc)
                    let fetchController = FetchController()
                    let existingUser = fetchController.fetchUser(userRep: loggedIn.user)
                    if existingUser == nil {
                        let user = loggedIn.user
                        let context = CoreDataStack.shared.container.newBackgroundContext()
                        User(identifier: user.identifier ?? 404, username: user.username, email: user.email!, context: context)
                        context.performAndWait {
                            do {
                                try context.save()
                            } catch {
                                print("error saving logged in user: \(error)")
                            }
                        }

                        completion()
                        return
                    } else {
                        //`String(describing:` to silence warning
                        print("Bad Status Code: \(String(describing: response.statusCode))")
                    }
                }
                completion()
            }
        }
    }

    /// Log out the active user
    func logoutUser() {
        AuthService.activeUser = nil
    }
}
