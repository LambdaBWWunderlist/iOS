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
    //
    ///The currently logged in user
    ///
    /// Static so it's always accessible and always the same user (until another user is logged in)
    static var activeUser: UserRepresentation?
    static let ironMan = UserRepresentation(identifier: nil, username: "ironman", password: "iam!ronman")

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
    func registerUser(with username: String,
                      and password: String,
                      and email: String,
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
                    to: UserDetails.self,
                    data: data
                    ) else { return }
                registerUser = returnedUserDetails.user
                AuthService.activeUser = registerUser
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
                    guard let loggedIn = self.networkService.decode(
                        to: UserDetails.self,
                        data: data
                    ) else { return }
                    //assign the static activeUser
                    AuthService.activeUser = loggedIn.user
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

    /// Log out the active user
    func logoutUser() {
        AuthService.activeUser = nil
        //global function to return user to login screen? local method here?
    }
}
