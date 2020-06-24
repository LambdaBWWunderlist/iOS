//
//  TodoRepresentation.swift
//  Wunderlist
//
//  Created by Kenny on 6/22/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//
import Foundation

struct TodoRepresentation: Codable {
    let identifier: Int
    var completed: Bool
    let name: String
    let recurring: String
    let username: String
    let dueDate: Date

    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case completed
        case name
        case recurring
        case dueDate = "due_date"
        case username
    }

}
