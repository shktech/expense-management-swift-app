import SwiftUI

struct EditExpenseForm: View {
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
                AllAmountsComponent(amount: $amount, selectedCurrency: $selectedCurrency, convertedAmount: $convertedAmount, targetCurrency: authManager.user?.currency ?? "USD", accessToken: authManager.accessToken ?? "")
                if selectedTypeRequiresCity {
                    CityPickerView<CommonDataManager>(selectedCity: $selectedCity, isEditable: $isEditable)
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
            TextInputView(title: "Origin", text: $origin, isEditable: $isEditable, placeholder: "---")
            TextInputView(title: "Destination", text: $destination, isEditable: $isEditable, placeholder: "---")
        }
    }

    var autoRentalFields: some View {
        VStack(alignment: .leading, spacing: 10) {
            CarRentalPickerView<CommonDataManager>(selectedRental: $rentalAgency, isEditable: $isEditable)
            CarTypeInputField<CommonDataManager>(selectedCar: $carType, isEditable: $isEditable)
        }
    }

    var businessMealsFields: some View {
        MealCategoriesPickerView<CommonDataManager>(selectedMeal: $mealCategory, isEditable: $isEditable)
    }

    var entertainmentFields: some View {
        VStack(alignment: .leading, spacing: 10) {
            TextInputView(title: "Name of Establishment", text: $establishmentName, isEditable: $isEditable, placeholder: "---")
            TextInputView(title: "City", text: $selectedCity, isEditable: $isEditable, placeholder: "---")
            TextInputView(title: "Business Topic", text: $businessTopic, isEditable: $isEditable, placeholder: "---")
            TextInputView(title: "Total Attendees", text: Binding(
                get: { String(totalAttendees) },
                set: { totalAttendees = Int($0) ?? 0 }
            ), isEditable: $isEditable, placeholder: "---")
            if expenseItem.expenseType == .entertainment {
                RelashionshipToPaiPickerView<CommonDataManager>(selectedRelation: $relationshipToPAI, isEditable: $isEditable)
            } else {
                TextInputView(title: "Attendees (Names)", text: $employeeNames, isEditable: $isEditable, placeholder: "---")
            }
        }
    }

    var hotelFields: some View {
        TextInputView(title: "Hotel Name", text: $hotelName, isEditable: $isEditable, placeholder: "---")
    }

    var mileageFields: some View {
        VStack(alignment: .leading, spacing: 10) {
            TextInputView(title: "Origin", text: $origin, isEditable: $isEditable, placeholder: "---")
            TextInputView(title: "Destination", text: $destination, isEditable: $isEditable, placeholder: "---")
            TextInputView(title: "Distance", text: $distance, isEditable: $isEditable, placeholder: "---")
            MileageRatePickerView<CommonDataManager>(selectedMileage: $mileageRate, isEditable: $isEditable)
        }
    }

    var telephoneCellFields: some View {
        TextInputView(title: "Carrier", text: $carrier, isEditable: $isEditable, placeholder: "---")
    }

    var justificationContainer: some View {
        TextInputView(title: "Justification", text: $justification, isEditable: $isEditable, placeholder: "")
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
                    print("Created expense item successfully.")
                    isLoading = false
                case .failure(let error):
                    print("Failed to create expense item: \(error.localizedDescription)")
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
}
