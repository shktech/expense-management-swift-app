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

//struct Reports: Codable, Identifiable {
//    var id: UUID = UUID()
//    var name: String
//    var date: Date
//    var purpose: String
//    var status: Bool
//    var expenseItems: [ExpenseItem]
//    
//    var value: Double {
//        var value: Double = 0
//        for expenseItem in expenseItems {
//            value += expenseItem.value
//        }
//        return value
//    }
//}


// MARK: - WelcomeElementstruct Reports: Codable {
struct Reports: Codable {
    let id: Int
    let user: String
    let reportNumber: String
    let reportStatus: String
    let reportDate: String
    let expenseType: String
    let purpose: String
    let paymentMethod: String
    let reportAmount: String
    let reportCurrency: String
    let reportSubmitDate: String?
    let integrationStatus: String
    let integrationDate: String?
    let errorMessage: String?
    let createdAt: Date
    let updatedAt: Date
    var expenseItems: [ExpenseItem] = []
    
    enum CodingKeys: String, CodingKey {
        case id
        case user
        case reportNumber = "report_number"
        case reportStatus = "report_status"
        case reportDate = "report_date"
        case expenseType = "expense_type"
        case purpose
        case paymentMethod = "payment_method"
        case reportAmount = "report_amount"
        case reportCurrency = "report_currency"
        case reportSubmitDate = "report_submit_date"
        case integrationStatus = "integration_status"
        case integrationDate = "integration_date"
        case errorMessage = "error_message"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

struct AllReports: Codable {
    let reports: [Reports]
}

//struct ExpenseItem: Codable, Identifiable {
//    var id = UUID()
//    var type: Types
//    var date: Date
//    var value: Double
//    var purpose: String
//    var preferredPaymentMethod: CreditCard
//    var currency: String
//}

struct ExpenseItem: Codable {
    let id, report: Int
    let expenseType, expenseDate, receiptAmount, receiptCurrency: String
    let justification, note: String
    let s3Path, nameOfEstablishment, city, hotelName: String?
    let hotelDailyBaseRate: HotelDailyBaseRate?
    let createdAt, updatedAt: Date
    let presignedURL: String?
    let mealCategory, employeeNames: String?
    let totalEmployees: Int?
    let companyCustomerName, businessTopic: String?
    let totalAttendees: Int?
    let relationshipToPai, airline, originDestination: String?

    enum CodingKeys: String, CodingKey {
        case id, report
        case expenseType = "expense_type"
        case expenseDate = "expense_date"
        case receiptAmount = "receipt_amount"
        case receiptCurrency = "receipt_currency"
        case justification, note
        case s3Path = "s3_path"
        case nameOfEstablishment = "name_of_establishment"
        case city
        case hotelName = "hotel_name"
        case hotelDailyBaseRate = "hotel_daily_base_rate"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case presignedURL = "presigned_url"
        case mealCategory = "meal_category"
        case employeeNames = "employee_names"
        case totalEmployees = "total_employees"
        case companyCustomerName = "company_customer_name"
        case businessTopic = "business_topic"
        case totalAttendees = "total_attendees"
        case relationshipToPai = "relationship_to_pai"
        case airline
        case originDestination = "origin_destination"
    }
}

// MARK: - HotelDailyBaseRate
struct HotelDailyBaseRate: Codable {
    let country, city: String
    let amount: Int
    let currency: String
}

enum Types: Codable {
    case Hotel, Food, Traveling
    
    var displayName: String {
        switch self {
        case .Hotel:
            return "Hotel"
        case .Food:
            return "Food"
        case .Traveling:
            return "Traveling"
        }
    }
}

struct AllUsers: Codable {
    var users: [User]
}
