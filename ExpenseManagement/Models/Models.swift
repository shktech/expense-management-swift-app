//
//  Models.swift
//  ExpenseManagement
//
//  Created by infra on 31/05/24.
//

import Foundation

struct User: Codable {
    var name: String
    var email: String
    var password: String
    var department: String
    var reports: [Reports]
}

struct Reports: Codable, Identifiable {
    var id: UUID = UUID()
    var name: String
    var type: Types
    var date: Date
    var purpose: String
    var value: Double
    var status: Bool
}

enum Types: Codable {
    case Hotel, Food, Traveling
}

struct AllUsers: Codable {
    var users: [User]
}
