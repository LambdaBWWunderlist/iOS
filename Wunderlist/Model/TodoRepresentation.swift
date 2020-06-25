//
//  TodoRepresentation.swift
//  Wunderlist
//
//  Created by Kenny on 6/22/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//
import Foundation

enum Recurring: String, CaseIterable, Codable {
    case daily
    case weekly
    case monthly
    case deleted
}

struct TodoRepresentation: Codable {
    let identifier: Int?
    var completed: Bool?
    let name: String
    let body: String?
    let recurring: Recurring?
    let username: String?
    var userID: Int?
    let dueDate: Date?
    var deletedDate: Date?

    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case completed
        case name
        case body
        case recurring
        case username
        case dueDate = "due_date"
        case userID = "user_id"
    }
}
