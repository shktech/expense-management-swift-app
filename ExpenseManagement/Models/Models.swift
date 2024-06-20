//
//  Models.swift
//  ExpenseManagement
//
//  Created by infra on 31/05/24.
//

import Foundation

struct User: Codable {
    var first_name: String?
    var last_name: String?
    var email: String?
    var phone_number: String?
    var department: String?
    var currency: String?
//    var reports: [Report]?
    var paymentMethods: [CreditCard]?
    var defaultPaymentMethod: Int?
}

struct CreditCard: Codable, Identifiable {
    var id = UUID()
    
    var cardNumber: String
    var expirationDate: Date
}

struct CreateReportRequest: Codable {
    let reportDate: String
    let expenseType: String
    let purpose: String
    let paymentMethod: String
    let reportAmount: Double
    let reportCurrency: String
    
    enum CodingKeys: String, CodingKey {
        case reportDate = "report_date"
        case expenseType = "expense_type"
        case purpose
        case paymentMethod = "payment_method"
        case reportAmount = "report_amount"
        case reportCurrency = "report_currency"
    }
}

struct Report: Codable {
    let id: String
    let user: String
    let reportNumber: String
    let reportStatus: String
    let reportSubmitDate: String?
    let integrationStatus: String?
    let integrationDate: String?
    let reportDate: String
    let expenseType: String
    let purpose: String
    let paymentMethod: String
    let reportAmount: String
    let reportCurrency: String
    let createdAt: String
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case user
        case reportNumber = "report_number"
        case reportStatus = "report_status"
        case reportSubmitDate = "report_submit_date"
        case integrationStatus = "integration_status"
        case integrationDate = "integration_date"
        case reportDate = "report_date"
        case expenseType = "expense_type"
        case purpose
        case paymentMethod = "payment_method"
        case reportAmount = "report_amount"
        case reportCurrency = "report_currency"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

struct CreateExpenseItemRequest: Codable {
    let expenseType: String
    let expenseDate: String
    let receiptAmount: String
    let receiptCurrency: String
    let justification: String
    let note: String
    let fileName: String?

    enum CodingKeys: String, CodingKey {
        case expenseType = "expense_type"
        case expenseDate = "expense_date"
        case receiptAmount = "receipt_amount"
        case receiptCurrency = "receipt_currency"
        case justification
        case note
        case fileName = "filename"
    }
}


struct ExpenseItem: Codable {
    let id: String?
    let airline: String?
    let rentalAgency: String?
    let carType: String?
    let mealCategory: String?
    let relationshipToPAI: String?
    let city: String?
    let hotelDailyBaseRate: String?
    let mileageRate: String?
    let presignedURL: String?
    let filename: String?
    let expenseType: String
    let expenseDate: String
    let receiptAmount: String
    let receiptCurrency: String
    let justification: String
    let note: String?
    let s3Path: String?
    let originDestination: String?
    let employeeNames: String?
    let totalEmployees: Int?
    let companyCustomerName: String?
    let businessTopic: String?
    let totalAttendees: Int?
    let nameOfEstablishment: String?
    let hotelName: String?
    let carrier: String?
    let distance: String?
    let createdAt: String?
    let updatedAt: String?
    let report: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case airline
        case rentalAgency = "rental_agency"
        case carType = "car_type"
        case mealCategory = "meal_category"
        case relationshipToPAI = "relationship_to_pai"
        case city
        case hotelDailyBaseRate = "hotel_daily_base_rate"
        case mileageRate = "mileage_rate"
        case presignedURL = "presigned_url"
        case filename
        case expenseType = "expense_type"
        case expenseDate = "expense_date"
        case receiptAmount = "receipt_amount"
        case receiptCurrency = "receipt_currency"
        case justification
        case note
        case s3Path = "s3_path"
        case originDestination = "origin_destination"
        case employeeNames = "employee_names"
        case totalEmployees = "total_employees"
        case companyCustomerName = "company_customer_name"
        case businessTopic = "business_topic"
        case totalAttendees = "total_attendees"
        case nameOfEstablishment = "name_of_establishment"
        case hotelName = "hotel_name"
        case carrier
        case distance
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case report
    }
}

enum ExpenseType: String, CaseIterable, Identifiable {
    case airFare = "AirFare"
    case airlineClubMembershipDues = "Airline Club Membership Dues"
    case airlineFees = "Airline Fees"
    case autoRental = "Auto Rental"
    case automobile = "Automobile"
    case businessMeals = "Business Meals"
    case companySponsorCDFO = "Company Sponsor - CDFO"
    case companySponsorVPDF = "Company Sponsor - VPDF"
    case customerGifts = "Customer Gifts"
    case dataProcessingDisksManual = "Data Processing-Disks, Manual"
    case duesSubscriptions = "Dues & Subscriptions"
    case entertainment = "Entertainment"
    case entertainmentLevi = "Entertainment - Levi"
    case fieldEngineerSupplies = "Field Engineer Supplies"
    case gas = "GAS"
    case hotel = "Hotel"
    case internetHome = "Internet - Home"
    case internetHotelAirplane = "Internet - Hotel/Airplane"
    case laundry = "Laundry"
    case mileage = "Mileage"
    case officeSupplies = "Office Supplies"
    case otherMarketingExpenses = "Other Marketing Expenses"
    case otherTaxiTrainLimoToll = "Other-TaxiTrainLimoToll"
    case parkingAndToll = "Parking and Toll"
    case otherEmployeeExpenses = "Other Employee Expenses"
    case postageShippingCharges = "Postage/Shipping Charges"
    case prepaidExpenseFutureMonths = "Prepaid Expense Future Months"
    case seminarsTraining = "Seminars & Training"
    case telephoneCell = "Telephone - Cell"
    case telephoneHome = "Telephone - Home"
    case telephoneSupplies = "Telephone - Supplies"
    case tips = "Tips"
    case travelAgentFee = "Travel Agent Fee"
    case marketingDevelopment = "Marketing Development"
    
    var id: String { self.rawValue }
    var displayName: String { self.rawValue }
}


struct AllUsers: Codable {
    var users: [User]
}

struct Airline: Codable {
    let id: Int
    let value: String
}

struct CarType: Codable {
    let value: String
    let description: String
}

struct City: Codable {
    let value: String
}

struct HotelDailyBaseRate: Codable {
    let country: String
    let city: String
    let amount: String
    let currency: String
}

struct MealCategory: Codable {
    let value: String
}

struct MileageRate: Codable {
    let rate: String
    let title: String
}

struct RelationshipToPAI: Codable {
    let value: String
}

struct RentalAgency: Codable {
    let value: String
}
