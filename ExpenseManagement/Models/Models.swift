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
    let expenseType: String?
    let expenseDate: String?
    let receiptAmount: String?
    let receiptCurrency: String?
    let justification: String?
    let note: String?
    let fileName: String?
    let airline: String?
    let rentalAgency: String?
    let carType: String?
    let mealCategory: String?
    let relationshipToPAI: String?
    let city: String?
    let hotelDailyBaseRate: String?
    let mileageRate: String?
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

    enum CodingKeys: String, CodingKey {
        case expenseType = "expense_type"
        case expenseDate = "expense_date"
        case receiptAmount = "receipt_amount"
        case receiptCurrency = "receipt_currency"
        case justification
        case note
        case fileName = "filename"
        case airline
        case rentalAgency = "rental_agency"
        case carType = "car_type"
        case mealCategory = "meal_category"
        case relationshipToPAI = "relationship_to_pai"
        case city
        case hotelDailyBaseRate = "hotel_daily_base_rate"
        case mileageRate = "mileage_rate"
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
    }

    init(expenseType: String? = nil,
         expenseDate: String? = nil,
         receiptAmount: String? = nil,
         receiptCurrency: String? = nil,
         justification: String? = nil,
         note: String? = nil,
         fileName: String? = nil,
         airline: String? = nil,
         rentalAgency: String? = nil,
         carType: String? = nil,
         mealCategory: String? = nil,
         relationshipToPAI: String? = nil,
         city: String? = nil,
         hotelDailyBaseRate: String? = nil,
         mileageRate: String? = nil,
         originDestination: String? = nil,
         employeeNames: String? = nil,
         totalEmployees: Int? = nil,
         companyCustomerName: String? = nil,
         businessTopic: String? = nil,
         totalAttendees: Int? = nil,
         nameOfEstablishment: String? = nil,
         hotelName: String? = nil,
         carrier: String? = nil,
         distance: String? = nil) {
        
        self.expenseType = expenseType
        self.expenseDate = expenseDate
        self.receiptAmount = receiptAmount
        self.receiptCurrency = receiptCurrency
        self.justification = justification
        self.note = note
        self.fileName = fileName
        self.airline = airline
        self.rentalAgency = rentalAgency
        self.carType = carType
        self.mealCategory = mealCategory
        self.relationshipToPAI = relationshipToPAI
        self.city = city
        self.hotelDailyBaseRate = hotelDailyBaseRate
        self.mileageRate = mileageRate
        self.originDestination = originDestination
        self.employeeNames = employeeNames
        self.totalEmployees = totalEmployees
        self.companyCustomerName = companyCustomerName
        self.businessTopic = businessTopic
        self.totalAttendees = totalAttendees
        self.nameOfEstablishment = nameOfEstablishment
        self.hotelName = hotelName
        self.carrier = carrier
        self.distance = distance
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(expenseType, forKey: .expenseType)
        try container.encodeIfPresent(expenseDate, forKey: .expenseDate)
        try container.encodeIfPresent(receiptAmount, forKey: .receiptAmount)
        try container.encodeIfPresent(receiptCurrency, forKey: .receiptCurrency)
        try container.encodeIfPresent(justification, forKey: .justification)
        try container.encodeIfPresent(note, forKey: .note)
        try container.encodeIfPresent(fileName, forKey: .fileName)
        try container.encodeIfPresent(airline, forKey: .airline)
        try container.encodeIfPresent(rentalAgency, forKey: .rentalAgency)
        try container.encodeIfPresent(carType, forKey: .carType)
        try container.encodeIfPresent(mealCategory, forKey: .mealCategory)
        try container.encodeIfPresent(relationshipToPAI, forKey: .relationshipToPAI)
        try container.encodeIfPresent(city, forKey: .city)
        try container.encodeIfPresent(hotelDailyBaseRate, forKey: .hotelDailyBaseRate)
        try container.encodeIfPresent(mileageRate, forKey: .mileageRate)
        try container.encodeIfPresent(originDestination, forKey: .originDestination)
        try container.encodeIfPresent(employeeNames, forKey: .employeeNames)
        try container.encodeIfPresent(totalEmployees, forKey: .totalEmployees)
        try container.encodeIfPresent(companyCustomerName, forKey: .companyCustomerName)
        try container.encodeIfPresent(businessTopic, forKey: .businessTopic)
        try container.encodeIfPresent(totalAttendees, forKey: .totalAttendees)
        try container.encodeIfPresent(nameOfEstablishment, forKey: .nameOfEstablishment)
        try container.encodeIfPresent(hotelName, forKey: .hotelName)
        try container.encodeIfPresent(carrier, forKey: .carrier)
        try container.encodeIfPresent(distance, forKey: .distance)
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
    // How I recomend storing the image
    // If we want to allow the user to update more than one image, this should be an array
//    var imageData: Data?
    
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

struct Airline: Codable, Identifiable {
    var id: String { value }
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
    let id: Int
    let country: String
    let city: String
    let amount: String
    let currency: String
}

struct MealCategory: Codable {
    let value: String
}

struct MileageRate: Codable {
    let id: Int
    let rate: String
    let title: String
}

struct RelationshipToPAI: Codable {
    let value: String
}

struct RentalAgency: Codable {
    let value: String
}
