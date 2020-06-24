//
//  Token.swift
//  Wunderlist
//
//  Created by Kenny on 6/23/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import Foundation

struct Token: Codable {
    var jsonWebToken: String

    enum codingKeys: String, CodingKey {
        case jsonWebToken = "token"
    }
}
