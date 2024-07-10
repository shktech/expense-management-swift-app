import SwiftUI
import FormValidator

struct EditExpenseForm: View {
    @Environment(\.presentationMode) var presentationMode
    let allowEdit: Bool
    let report: Report
    @State var selectedCity: String = ""
    @State var date: Date = Date()
    @State var selectedCurrency: String = "USD"
    @State var amount: String = ""
    @State var convertedAmount: Double = 0.0
    @State var justification: String = ""
    @State var isLoading: Bool = false
    @State var isShowingFilePicker: Bool = false
    @State var isShowingImagePicker: Bool = false
    @State var selectedFileURL: URL?
    @State var isShowingActionSheet: Bool = false
    @StateObject private var commonDataManager = CommonDataManager.instance
    @EnvironmentObject var authManager: AuthenticationManager
    @EnvironmentObject var globalState: GlobalStateManager
    private let dao = DAO.instance

    // Editing fields
    let expenseItem: ExpenseItem

    @State var isEditable: Bool = false
    @State var fileAction: FileAction?

    // Dynamic Fields
    @State var airline: String = ""
    @State var origin: String = ""
    @State var destination: String = ""
    @State var rentalAgency: String = ""
    @State var carType: String = ""
    @State var mealCategory: String = ""
    @State var employeeNames: String = ""
    @State var establishmentName: String = ""
    @State var businessTopic: String = ""
    @State var totalAttendees: Int = 0
    @State var relationshipToPAI: String = ""
    @State var hotelName: String = ""
    @State var hotelDailyBaseRate: String = ""
    @State var distance: String = ""
    @State var mileageRate: String = ""
    @State var carrier: String = ""
    @State var companyCustomerName: String = ""
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    @ObservedObject var form = FormValidatorManager()
    
    var body: some View {
        ZStack {
            VStack {
                content
                    .padding()
                    .frame(maxHeight: .infinity)
                saveButton
                    .padding(.horizontal)
            }
        }
        .loadingOverlay(isLoading: $isLoading)
        .onAppear {
            loadExpenseData()
        }
    }

    var content: some View {
        ScrollView {
            VStack(spacing: 15) {
                HStack {
                    reportHeader
                    Button(action: {
                        isEditable.toggle()
                    }) {
                        Image(systemName: isEditable ? "pencil.slash" : "pencil")
                            .font(.title)
                            .foregroundStyle(.oceanBlue)
                    }.opacity(allowEdit ? 1 : 0)
                }
                WarningMessageView(expenseType: expenseItem.expenseType)
                DateFieldView(title: "Date", date: $date, isEditable: $isEditable)
                AllAmountsComponent(amount: $amount, selectedCurrency: $selectedCurrency, convertedAmount: $convertedAmount, isEditable: $isEditable, targetCurrency: authManager.user?.currency ?? "USD", accessToken: authManager.accessToken ?? "")
                if selectedTypeRequiresCity {
                    CityPickerView<CommonDataManager>(selectedCity: $selectedCity, isEditable: $isEditable)
                        .validation(form.cityValidation) { message in
                            Text(message.uppercased())
                                .foregroundColor(.red)
                                .font(.system(size: 14))
                        }
                        .onChange(of: selectedCity) { newValue in
                            form.updateCity(newValue)
                        }
                }
                specificFields
                justificationContainer
                FilePickerButton(allowEdit: allowEdit, selectedFileURL: $selectedFileURL, isShowingFilePicker: $isShowingFilePicker, isShowingImagePicker: $isShowingImagePicker, isShowingActionSheet: $isShowingActionSheet, showAlert: $showAlert, alertMessage: $alertMessage, isEditable: $isEditable)
            }.padding()
        }
    }

    var specificFields: some View {
        Group {
            switch expenseItem.expenseType {
            case .airFare:
                airFareFields
            case .autoRental:
                autoRentalFields
            case .businessMeals:
                businessMealsFields
            case .entertainment, .entertainmentLevi:
                entertainmentFields
            case .hotel:
                hotelFields
            case .mileage:
                mileageFields
            case .telephoneCell:
                telephoneCellFields
            default:
                EmptyView()
            }
        }
    }

    var airFareFields: some View {
        VStack(alignment: .leading, spacing: 15) {
            AirlinePickerView<CommonDataManager>(selectedAirline: $airline, isEditable: $isEditable)
                .validation(form.airlineValidation) { message in
                    Text(message.uppercased())
                        .foregroundColor(.red)
                        .font(.system(size: 14))
                }
                .onChange(of: airline) { newValue in
                    form.updateAirline(newValue)
                }
            TextInputView(title: "Origin", text: $origin, isEditable: $isEditable, validation: form.originValidation, placeholder: "---")
                .onChange(of: origin) { newValue in
                    form.updateOrigin(newValue)
                }
            TextInputView(title: "Destination", text: $destination, isEditable: $isEditable, validation: form.destinationValidation, placeholder: "---")
                .onChange(of: destination) { newValue in
                    form.updateDestination(newValue)
                }
        }
    }

    var autoRentalFields: some View {
        VStack(alignment: .leading, spacing: 10) {
            CarRentalPickerView<CommonDataManager>(selectedRental: $rentalAgency, isEditable: $isEditable)
                .validation(form.rentalAgencyValidation) { message in
                    Text(message.uppercased())
                        .foregroundColor(.red)
                        .font(.system(size: 14))
                }
                .onChange(of: rentalAgency) { newValue in
                    form.updateRentalAgency(newValue)
                }
            CarTypeInputField<CommonDataManager>(selectedCar: $carType, isEditable: $isEditable)
                .validation(form.carTypeValidation) { message in
                    Text(message.uppercased())
                        .foregroundColor(.red)
                        .font(.system(size: 14))
                }
                .onChange(of: carType) { newValue in
                    form.updateCarType(newValue)
                }
        }
    }

    var businessMealsFields: some View {
        MealCategoriesPickerView<CommonDataManager>(selectedMeal: $mealCategory, isEditable: $isEditable)
            .validation(form.mealCategoryValidation) { message in
                Text(message.uppercased())
                    .foregroundColor(.red)
                    .font(.system(size: 14))
            }
            .onChange(of: mealCategory) { newValue in
                form.updateMealCategory(newValue)
            }
    }

    var entertainmentFields: some View {
        VStack(alignment: .leading, spacing: 10) {
            TextInputView(title: "Name of Establishment", text: $establishmentName, isEditable: $isEditable, validation: form.establishmentNameValidation, placeholder: "---")
                .onChange(of: establishmentName) { newValue in
                    form.updateEstablishmentName(newValue)
                }
            TextInputView(title: "City", text: $selectedCity, isEditable: $isEditable, validation: form.cityValidation, placeholder: "---")
                .onChange(of: selectedCity) { newValue in
                    form.updateCity(newValue)
                }
            TextInputView(title: "Business Topic", text: $businessTopic, isEditable: $isEditable, validation: form.businessTopicValidation, placeholder: "---")
                .onChange(of: businessTopic) { newValue in
                    form.updateBusinessTopic(newValue)
                }
            TextInputView(title: "Total Attendees", text: Binding(
                get: { String(totalAttendees) },
                set: { totalAttendees = Int($0) ?? 0 }
            ), isEditable: $isEditable, validation: form.totalAttendeesValidation, placeholder: "---")
                .onChange(of: totalAttendees) { newValue in
                    form.updateTotalAttendees(String(newValue))
                }
            if expenseItem.expenseType == .entertainment {
                RelashionshipToPaiPickerView<CommonDataManager>(selectedRelation: $relationshipToPAI, isEditable: $isEditable)
                    .validation(form.relationshipToPAIValidation) { message in
                        Text(message.uppercased())
                            .foregroundColor(.red)
                            .font(.system(size: 14))
                    }
                    .onChange(of: relationshipToPAI) { newValue in
                        form.updateRelationshipToPAI(newValue)
                    }
            } else {
                TextInputView(title: "Attendees (Names)", text: $employeeNames, isEditable: $isEditable, validation: form.employeeNamesValidation, placeholder: "---")
                    .onChange(of: employeeNames) { newValue in
                        form.updateEmployeeNames(newValue)
                    }
            }
        }
    }

    var hotelFields: some View {
        VStack(alignment: .leading, spacing: 10) {
            TextInputView(title: "Hotel Name", text: $hotelName, isEditable: $isEditable, validation: form.hotelNameValidation, placeholder: "---")
                .onChange(of: hotelName) { newValue in
                    form.updateHotelName(newValue)
                }
            TextInputView(title: "Hotel Daily Base Rate", text: $hotelDailyBaseRate, isEditable: $isEditable, validation: form.hotelDailyBaseRateValidation, placeholder: "---")
                .onChange(of: hotelDailyBaseRate) { newValue in
                    form.updateHotelDailyBaseRate(newValue)
                }
        }
    }

    var mileageFields: some View {
        VStack(alignment: .leading, spacing: 10) {
            TextInputView(title: "Origin", text: $origin, isEditable: $isEditable, validation: form.originValidation, placeholder: "---")
                .onChange(of: origin) { newValue in
                    form.updateOrigin(newValue)
                }
            TextInputView(title: "Destination", text: $destination, isEditable: $isEditable, validation: form.destinationValidation, placeholder: "---")
                .onChange(of: destination) { newValue in
                    form.updateDestination(newValue)
                }
            TextInputView(title: "Distance", text: $distance, isEditable: $isEditable, validation: form.distanceValidation, placeholder: "---")
                .onChange(of: distance) { newValue in
                    form.updateDistance(newValue)
                }
            MileageRatePickerView<CommonDataManager>(selectedMileage: $mileageRate, isEditable: $isEditable)
                .validation(form.mileageRateValidation) { message in
                    Text(message.uppercased())
                        .foregroundColor(.red)
                        .font(.system(size: 14))
                }
                .onChange(of: mileageRate) { newValue in
                    form.updateMileageRate(newValue)
                }
        }
    }

    var telephoneCellFields: some View {
        TextInputView(title: "Carrier", text: $carrier, isEditable: $isEditable, validation: form.carrierValidation, placeholder: "---")
            .onChange(of: carrier) { newValue in
                form.updateCarrier(newValue)
            }
    }

    var justificationContainer: some View {
        TextInputView(title: "Justification", text: $justification, isEditable: $isEditable, validation: form.justificationValidation, placeholder: "")
            .onChange(of: justification) { newValue in
                form.updateJustification(newValue)
            }
    }

    var saveButton: some View {
        Button(action: {
            submitItem()
        }, label: {
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .foregroundStyle(.oceanBlue)
                Text("Save")
                    .foregroundStyle(.white)
                    .font(Font.custom("Poppins", size: 18).weight(.semibold))
            }
        }).frame(height: 50)
        .disabled(!isEditable)
        .opacity(allowEdit && isEditable ? 1 : 0)
    }
    
    var reportHeader: some View {
        HStack {
            VStack(alignment: .leading, spacing: 3) {
                Text(report.reportNumber)
                    .font(.system(size: 32).weight(.semibold))
                if let date = DateFormatter.apiDate.date(from: report.reportDate) {
                    Text(DateFormatter.userFriendly.string(from: date))
                        .font(.system(size: 17).weight(.semibold))
                        .foregroundStyle(.gray)
                } else {
                    Text("Unknown Date")
                        .font(.system(size: 17).weight(.semibold))
                        .foregroundStyle(.gray)
                }
                Text(report.purpose)
                    .font(.system(size: 17).weight(.semibold))
            }
            Spacer()
        }
    }

    func submitItem() {
        guard let accessToken = authManager.accessToken else {
            print("Access token not found")
            return
        }

        isLoading = true

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let formattedDate = dateFormatter.string(from: date)
        let fileName = selectedFileURL?.lastPathComponent ?? ""

        let newItem = CreateExpenseItemRequest(
            expenseType: expenseItem.expenseType.rawValue,
            expenseDate: formattedDate,
            receiptAmount: amount,
            receiptCurrency: selectedCurrency,
            justification: justification.isEmpty ? nil : justification,
            note: "N/A",
            fileName: fileName.isEmpty ? nil : fileName,
            airline: airline.isEmpty ? nil : airline,
            rentalAgency: rentalAgency.isEmpty ? nil : rentalAgency,
            carType: carType.isEmpty ? nil : carType,
            mealCategory: mealCategory.isEmpty ? nil : mealCategory,
            relationshipToPAI: relationshipToPAI.isEmpty ? nil : relationshipToPAI,
            city: selectedCity.isEmpty ? nil : selectedCity,
            hotelDailyBaseRate: hotelDailyBaseRate.isEmpty ? nil : hotelDailyBaseRate,
            mileageRate: mileageRate.isEmpty ? nil : mileageRate,
            originDestination: origin.isEmpty ? nil : origin,
            employeeNames: employeeNames.isEmpty ? nil : employeeNames,
            totalEmployees: totalAttendees,
            companyCustomerName: companyCustomerName.isEmpty ? nil : companyCustomerName,
            businessTopic: businessTopic.isEmpty ? nil : businessTopic,
            totalAttendees: totalAttendees,
            nameOfEstablishment: establishmentName.isEmpty ? nil : establishmentName,
            hotelName: hotelName.isEmpty ? nil : hotelName,
            carrier: carrier.isEmpty ? nil : carrier,
            distance: distance.isEmpty ? nil : distance
        )

        dao.updateExpenseItem(reportId: report.id, itemId: expenseItem.id, expenseItemData: newItem, accessToken: accessToken) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    isLoading = false
                    presentationMode.wrappedValue.dismiss()
                case .failure(let error):
                    globalState.showMessage(title: "Error", message: "Failed to update expense item", type: .error)
                    isLoading = false
                }
            }
        }
    }

    private var selectedTypeRequiresCity: Bool {
        switch expenseItem.expenseType {
        case .entertainment, .entertainmentLevi, .hotel:
            return true
        default:
            return false
        }
    }
    
    private func getPreviewLink() {
        guard let accessToken = authManager.accessToken else {
            print("Access token not found")
            return
        }
    }

    private func loadExpenseData() {
        isLoading = true
        guard let accessToken = authManager.accessToken else {
            print("Access token not found")
            return
        }
        if (expenseItem.filename != nil) {
            dao.getImagePreviewLink(reportId: report.id, itemId: expenseItem.id, accessToken: accessToken) { result in
                switch result {
                case .success(let preview):
                    print(preview)
                    self.selectedFileURL = URL(string: preview.presignedURL)
                    initializeData()
                case .failure:
                    self.selectedFileURL = nil
                    initializeData()
                }
            }
        } else {
            self.selectedFileURL = nil
            initializeData()
        }
        isLoading = false
    }
    
    private func initializeData() {
        self.selectedCity = expenseItem.city ?? ""
        self.date = DateFormatter.apiDate.date(from: expenseItem.expenseDate) ?? Date()
        self.selectedCurrency = expenseItem.receiptCurrency
        self.amount = expenseItem.receiptAmount
        self.justification = expenseItem.justification
        self.airline = expenseItem.airline ?? ""
        self.origin = expenseItem.originDestination ?? ""
        self.rentalAgency = expenseItem.rentalAgency ?? ""
        self.carType = expenseItem.carType ?? ""
        self.mealCategory = expenseItem.mealCategory ?? ""
        self.employeeNames = expenseItem.employeeNames ?? ""
        self.establishmentName = expenseItem.nameOfEstablishment ?? ""
        self.businessTopic = expenseItem.businessTopic ?? ""
        self.totalAttendees = expenseItem.totalAttendees ?? 0
        self.relationshipToPAI = expenseItem.relationshipToPAI ?? ""
        self.hotelName = expenseItem.hotelName ?? ""
        self.hotelDailyBaseRate = expenseItem.hotelDailyBaseRate?.amount ?? ""
        self.distance = expenseItem.distance ?? ""
        self.mileageRate = expenseItem.mileageRate?.rate ?? ""
        self.carrier = expenseItem.carrier ?? ""
        self.companyCustomerName = expenseItem.companyCustomerName ?? ""
//        self.selectedFileURL = (expenseItem.filename != nil) ? URL(string: expenseItem.filename ?? "") : nil

    }
}


#Preview {
    EditExpenseForm(
        allowEdit: true,
        report: Report(
        id: "3",
        user: "user@gmail.com",
        reportNumber: "RPT789012",
        reportStatus: "Rejected",
        reportSubmitDate: "2023-03-10",
        integrationStatus: "Not Integrated",
        integrationDate: nil,
        reportDate: "2024-06-08",
        expenseType: "Hotel",
        purpose: "Hotel stay during conference",
        paymentMethod: "Debit Card",
        reportAmount: "500.00",
        reportCurrency: "USD",
        createdAt: "2023-03-08T09:00:00Z",
        updatedAt: "2023-03-10T14:00:00Z"
    ), expenseItem: ExpenseItem(
        id: "1",
        airline: "Delta",
        rentalAgency: "Hertz",
        carType: "SUV",
        mealCategory: "Lunch",
        relationshipToPAI: "Business",
        city: "New York",
        hotelDailyBaseRate: nil,
        mileageRate: nil,
        presignedURL: nil,
        filename: "receipt.pdf",
        expenseType: ExpenseType.hotel,
        expenseDate: "2023-06-08",
        receiptAmount: "500",
        receiptCurrency: "USD",
        justification: "Conference stay",
        note: nil,
        s3Path: nil,
        originDestination: "LAX",
        employeeNames: "John Doe",
        totalEmployees: 1,
        companyCustomerName: "Apple",
        businessTopic: "Tech Conference",
        totalAttendees: 100,
        nameOfEstablishment: "Hilton",
        hotelName: "Hilton",
        carrier: "Verizon",
        distance: "30",
        createdAt: nil,
        updatedAt: nil,
        report: 3
    ))
    .environmentObject(AuthenticationManager())
    .environmentObject(MockCommonDataManager())
    .environmentObject(GlobalStateManager())
}
