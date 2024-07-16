import Foundation
import FormValidator

class FormValidatorManager: ObservableObject {
    @Published
    var manager = FormManager(validationType: .immediate)
    
    // MARK: - NewReportView
    // Purpose
    @FormField(validator: NonEmptyValidator(message: "Please inform the purpose"))
    var purpose: String = ""
    lazy var purposeValidation = _purpose.validation(manager: manager)
    func updatePurpose(_ newPurpose: String) {
        purpose = newPurpose
    }
    
    // Report Type
    @FormField(validator: NonEmptyValidator(message: "Please inform the Report Type"))
    var reportType: String = ""
    lazy var reportTypeValidation = _reportType.validation(manager: manager)
    func updateReportType(_ newType: String) {
        reportType = newType
    }
    
    
    // MARK: - NewCreditCardForm
    // Credit Card Number
    @FormField(validator: NonEmptyValidator(message: "Please inform the credit card number"))
    var creditCardNumber: String = ""
    lazy var ccNumberValidation = _creditCardNumber.validation(manager: manager)
    func updateCCNumber(_ newCCNumber: String) {
        creditCardNumber = newCCNumber
    }
    
    // Exp Date
    @FormField(validator: NonEmptyValidator(message: "Please inform the expiration date"))
    var expDate: String = ""
    lazy var expDateValidation = _expDate.validation(manager: manager)
    func updateExpDate(_ newExpDate: String) {
        expDate = newExpDate
    }
    
    
    // MARK: - NewExpenseForm && EditExpenseForm
    // Credit Card Number
    @FormField(validator: NonEmptyValidator(message: "Please inform the credit card number"))
    var city: String = ""
    lazy var cityValidation = _city.validation(manager: manager)
    func updateCity(_ newCity: String) {
        city = newCity
    }
    
    // Justification
    @FormField(validator: NonEmptyValidator(message: "Please provide a justification"))
    var justification: String = ""
    lazy var justificationValidation = _justification.validation(manager: manager)
    
    func updateJustification(_ newJustification: String) {
        justification = newJustification
    }

    // Airline
    @FormField(validator: NonEmptyValidator(message: "Please provide the airline"))
    var airline: String = ""
    lazy var airlineValidation = _airline.validation(manager: manager)
    
    func updateAirline(_ newAirline: String) {
        airline = newAirline
    }

    // Origin
    @FormField(validator: NonEmptyValidator(message: "Please provide the origin"))
    var origin: String = ""
    lazy var originValidation = _origin.validation(manager: manager)
    
    func updateOrigin(_ newOrigin: String) {
        origin = newOrigin
    }

    // Destination
    @FormField(validator: NonEmptyValidator(message: "Please provide the destination"))
    var destination: String = ""
    lazy var destinationValidation = _destination.validation(manager: manager)
    
    func updateDestination(_ newDestination: String) {
        destination = newDestination
    }

    // Rental Agency
    @FormField(validator: NonEmptyValidator(message: "Please provide the rental agency"))
    var rentalAgency: String = ""
    lazy var rentalAgencyValidation = _rentalAgency.validation(manager: manager)
    
    func updateRentalAgency(_ newRentalAgency: String) {
        rentalAgency = newRentalAgency
    }

    // Car Type
    @FormField(validator: NonEmptyValidator(message: "Please provide the car type"))
    var carType: String = ""
    lazy var carTypeValidation = _carType.validation(manager: manager)
    
    func updateCarType(_ newCarType: String) {
        carType = newCarType
    }

    // Meal Category
    @FormField(validator: NonEmptyValidator(message: "Please provide the meal category"))
    var mealCategory: String = ""
    lazy var mealCategoryValidation = _mealCategory.validation(manager: manager)
    
    func updateMealCategory(_ newMealCategory: String) {
        mealCategory = newMealCategory
    }

    // Employee Names
    @FormField(validator: NonEmptyValidator(message: "Please provide the employee names"))
    var employeeNames: String = ""
    lazy var employeeNamesValidation = _employeeNames.validation(manager: manager)
    
    func updateEmployeeNames(_ newEmployeeNames: String) {
        employeeNames = newEmployeeNames
    }

    // Establishment Name
    @FormField(validator: NonEmptyValidator(message: "Please provide the establishment name"))
    var establishmentName: String = ""
    lazy var establishmentNameValidation = _establishmentName.validation(manager: manager)
    
    func updateEstablishmentName(_ newEstablishmentName: String) {
        establishmentName = newEstablishmentName
    }

    // Business Topic
    @FormField(validator: NonEmptyValidator(message: "Please provide the business topic"))
    var businessTopic: String = ""
    lazy var businessTopicValidation = _businessTopic.validation(manager: manager)
    
    func updateBusinessTopic(_ newBusinessTopic: String) {
        businessTopic = newBusinessTopic
    }

    // Total Attendees
    @FormField(validator: NonEmptyValidator(message: "Please provide the total attendees"))
    var totalAttendees: String = "0"
    lazy var totalAttendeesValidation = _totalAttendees.validation(manager: manager)
    
    func updateTotalAttendees(_ newTotalAttendees: String) {
        totalAttendees = newTotalAttendees
    }

    // Relationship to PAI
    @FormField(validator: NonEmptyValidator(message: "Please provide the relationship to PAI"))
    var relationshipToPAI: String = ""
    lazy var relationshipToPAIValidation = _relationshipToPAI.validation(manager: manager)
    
    func updateRelationshipToPAI(_ newRelationshipToPAI: String) {
        relationshipToPAI = newRelationshipToPAI
    }

    // Hotel Name
    @FormField(validator: NonEmptyValidator(message: "Please provide the hotel name"))
    var hotelName: String = ""
    lazy var hotelNameValidation = _hotelName.validation(manager: manager)
    
    func updateHotelName(_ newHotelName: String) {
        hotelName = newHotelName
    }

    // Hotel Daily Base Rate
    @FormField(validator: NonEmptyValidator(message: "Please provide the hotel daily base rate"))
    var hotelDailyBaseRate: String = ""
    lazy var hotelDailyBaseRateValidation = _hotelDailyBaseRate.validation(manager: manager)
    
    func updateHotelDailyBaseRate(_ newHotelDailyBaseRate: String) {
        hotelDailyBaseRate = newHotelDailyBaseRate
    }

    // Distance
    @FormField(validator: NonEmptyValidator(message: "Please provide the distance"))
    var distance: String = ""
    lazy var distanceValidation = _distance.validation(manager: manager)
    
    func updateDistance(_ newDistance: String) {
        distance = newDistance
    }

    // Mileage Rate
    @FormField(validator: NonEmptyValidator(message: "Please provide the mileage rate"))
    var mileageRate: String = ""
    lazy var mileageRateValidation = _mileageRate.validation(manager: manager)
    
    func updateMileageRate(_ newMileageRate: String) {
        mileageRate = newMileageRate
    }

    // Carrier
    @FormField(validator: NonEmptyValidator(message: "Please provide the carrier"))
    var carrier: String = ""
    lazy var carrierValidation = _carrier.validation(manager: manager)
    
    func updateCarrier(_ newCarrier: String) {
        carrier = newCarrier
    }

    // Company Customer Name
    @FormField(validator: NonEmptyValidator(message: "Please provide the company customer name"))
    var companyCustomerName: String = ""
    lazy var companyCustomerNameValidation = _companyCustomerName.validation(manager: manager)
    
    func updateCompanyCustomerName(_ newCompanyCustomerName: String) {
        companyCustomerName = newCompanyCustomerName
    }
    
    
    
    // MARK: - SignUpView
    @FormField(validator: NonEmptyValidator(message: "First name is required"))
    var firstName: String = ""
    lazy var firstNameValidation = _firstName.validation(manager: manager)

    @FormField(validator: NonEmptyValidator(message: "Last name is required"))
    var lastName: String = ""
    lazy var lastNameValidation = _lastName.validation(manager: manager)

    @FormField(validator: EmailValidator(message: "Invalid email"))
    var email: String = ""
    lazy var emailValidation = _email.validation(manager: manager)

    @PasswordFormField(message: (
        empty: "Password is required",
        notMatching: "Passwords do not match",
        invalidPattern: "Your password must be at least 8 characters long and include at least one uppercase letter, one lowercase letter, one number, and one special character."
    ))
    var password: String = ""
    lazy var passwordValidation = _password.validation(
        manager: manager,
        other: _confirmPassword,
        pattern: try! NSRegularExpression(
            pattern: "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[-_@$!%*#?&])[A-Za-z\\d-_@$!%*#?&]{8,}$",
            options: .caseInsensitive)
    )

    @PasswordFormField(message: (
        empty: "Confirm password is required",
        notMatching: "Passwords do not match",
        invalidPattern: "Your password must be at least 8 characters long and include at least one uppercase letter, one lowercase letter, one number, and one special character."
    ))
    var confirmPassword: String = ""
    lazy var confirmPasswordValidation = _confirmPassword.validation(
        manager: manager,
        other: _password,
        pattern: try! NSRegularExpression(
            pattern: "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[-_@$!%*#?&])[A-Za-z\\d-_@$!%*#?&]{8,}$",
            options: .caseInsensitive)
    )

    @FormField(validator: NonEmptyValidator(message: "Phone number is required"))
    var phoneNumber: String = ""
    lazy var phoneNumberValidation = _phoneNumber.validation(manager: manager)

    @FormField(validator: NonEmptyValidator(message: "Department is required"))
    var department: String = ""
    lazy var departmentValidation = _department.validation(manager: manager)
}

