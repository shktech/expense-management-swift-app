//
//  Models.swift
//  ExpenseManagement
//
//  Created by infra on 31/05/24.
//

import Foundation

struct User: Codable {
    var name: String
    var username: String
    var email: String
    var password: String
    var department: String
    var reports: [Reports]
    var paymentMethods: [CreditCard]
    var defaultPaymentMethod: Int?
}

struct CreditCard: Codable, Identifiable {
    var id = UUID()
    
    var cardNumber: String
    var expirationDate: Date
}

struct Reports: Codable, Identifiable {
    var id: UUID = UUID()
    var name: String
    var date: Date
    var purpose: String
    var value: Double
    var status: Bool
}

struct ExpenseItem: Codable, Identifiable {
    var id = UUID()
    var type: Types
    var date: Date
    var purpose: String
    var preferredPaymentMethod: CreditCard
    var currency: String
}

enum Types: Codable {
    case Hotel, Food, Traveling
}

struct AllUsers: Codable {
    var users: [User]
}
