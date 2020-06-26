//
//  UserRepresentation.swift
//  Wunderlist
//
//  Created by Kenny on 6/21/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import Foundation

///Used to decode loginUser
struct UserDetails: Codable {
    var user: UserRepresentation
    var token: String?
}

struct UserRepresentation: Codable {
    let identifier: Int?
    let username: String
    let password: String?
    var email: String?
    var token: String?

    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case username
        case password
        case email
        case token
    }

}
