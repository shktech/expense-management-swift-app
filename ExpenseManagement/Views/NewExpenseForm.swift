import SwiftUI

struct NewExpenseForm: View {
    @Binding var isShowingSelf: Bool
    let report: Report
    let countries: [String] = ["USD", "CAD", "JPY"]
    let selectedType: ExpenseType
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
    
    private let dao = DAO.instance
    
    var body: some View {
        ZStack {
            VStack {
                content
                    .padding()
                    .frame(maxHeight: .infinity)
                saveButton
                    .padding(.horizontal)
            }
        }.loadingOverlay(isLoading: $isLoading)
    }
    
    var content: some View {
        ScrollView {
            VStack(spacing: 15) {
                reportHeader
                WarningMessageView(expenseType: selectedType)
                DateFieldView(title: "Date", date: $date, isEditable: .constant(true))
                if selectedTypeRequiresCity {
                    CityPickerView<CommonDataManager>(selectedCity: $selectedCity, isEditable: .constant(true))
                }
                AllAmountsComponent(amount: $amount, selectedCurrency: $selectedCurrency, convertedAmount: $convertedAmount, isEditable: .constant(true), targetCurrency: authManager.user?.currency ?? "USD", accessToken: authManager.accessToken ?? "")
                specificFields
                justificationContainer
                FilePickerButton(allowEdit: true, selectedFileURL: $selectedFileURL, isShowingFilePicker: $isShowingFilePicker, isShowingImagePicker: $isShowingImagePicker, isShowingActionSheet: $isShowingActionSheet, showAlert: $showAlert, alertMessage: $alertMessage, isEditable: .constant(true))
            }.padding()
        }
    }
    
    var specificFields: some View {
        Group {
            switch selectedType {
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
            AirlinePickerView<CommonDataManager>(selectedAirline: $airline, isEditable: .constant(true))
            TextInputView(title: "Origin", text: $origin, isEditable: .constant(true), validation: nil, placeholder: "---")
            TextInputView(title: "Destination", text: $destination, isEditable: .constant(true), validation: nil, placeholder: "---")
        }
    }
    
    var autoRentalFields: some View {
        VStack(alignment: .leading, spacing: 10) {
            CarRentalPickerView<CommonDataManager>(selectedRental: $rentalAgency, isEditable: .constant(true))
            CarTypeInputField<CommonDataManager>(selectedCar: $carType, isEditable: .constant(true))
        }
    }
    
    var businessMealsFields: some View {
        MealCategoriesPickerView<CommonDataManager>(selectedMeal: $mealCategory, isEditable: .constant(true))
    }
    
    var entertainmentFields: some View {
        VStack(alignment: .leading, spacing: 10) {
            TextInputView(title: "Name of Establishment", text: $establishmentName, isEditable: .constant(true), validation: nil, placeholder: "---")
            TextInputView(title: "City", text: $selectedCity, isEditable: .constant(true), validation: nil, placeholder: "---")
            TextInputView(title: "Business Topic", text: $businessTopic, isEditable: .constant(true), validation: nil, placeholder: "---")
            TextInputView(title: "Total Attendees", text: Binding(
                get: { String(totalAttendees) },
                set: { totalAttendees = Int($0) ?? 0 }
            ), isEditable: .constant(true), validation: nil, placeholder: "---")
            if selectedType == .entertainment {
                RelashionshipToPaiPickerView<CommonDataManager>(selectedRelation: $relationshipToPAI, isEditable: .constant(true))
            } else {
                TextInputView(title: "Attendees (Names)", text: $employeeNames, isEditable: .constant(true), validation: nil, placeholder: "---")
            }
        }
    }
    
    var hotelFields: some View {
        TextInputView(title: "Hotel Name", text: $hotelName, isEditable: .constant(true), validation: nil, placeholder: "---")
    }
    
    var mileageFields: some View {
        VStack(alignment: .leading, spacing: 10) {
            TextInputView(title: "Origin", text: $origin, isEditable: .constant(true), validation: nil, placeholder: "---")
            TextInputView(title: "Destination", text: $destination, isEditable: .constant(true), validation: nil, placeholder: "---")
            TextInputView(title: "Distance", text: $distance, isEditable: .constant(true), validation: nil, placeholder: "---")
            MileageRatePickerView<CommonDataManager>(selectedMileage: $mileageRate, isEditable: .constant(true))
        }
    }
    
    var telephoneCellFields: some View {
        TextInputView(title: "Carrier", text: $carrier, isEditable: .constant(true), validation: nil, placeholder: "---")
    }
    
    var justificationContainer: some View {
        TextInputView(title: "Justification", text: $justification, isEditable: .constant(true), validation: nil, placeholder: "")
    }
    
    var saveButton: some View {
        Button(action: {
            submitItem()
        }, label: {
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .foregroundStyle(.oceanBlue)
                Text("+ Add Expense")
                    .foregroundStyle(.white)
                    .font(Font.custom("Poppins", size: 18).weight(.semibold))
            }
        }).frame(height: 55)
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
                Text(report.expenseType)
                    .font(.system(size: 17).weight(.semibold))
                Text(selectedType.rawValue)
                    .font(Font.custom("Poppins", size: 18).weight(.semibold))
                    .foregroundStyle(.oceanBlue)
            }
            Spacer()
        }
    }
    
    private func showImagePicker(sourceType: UIImagePickerController.SourceType) {
        guard UIImagePickerController.isSourceTypeAvailable(sourceType) else {
            return
        }
        isShowingImagePicker = true
    }
    
    private var selectedTypeRequiresCity: Bool {
        switch selectedType {
        case .entertainment, .entertainmentLevi, .hotel:
            return true
        default:
            return false
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
            expenseType: selectedType.rawValue,
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
        
        dao.addExpenseItemToReport(reportId: report.id, expenseItemData: newItem, accessToken: accessToken, selectedFileURL: selectedFileURL) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    print("Created expense item successfully.")
                    isLoading = false
                    isShowingSelf.toggle()
                case .failure(let error):
                    print("Failed to create expense item: \(error.localizedDescription)")
                    isLoading = false
                }
            }
        }
    }
}

#Preview {
    NewExpenseForm(isShowingSelf: .constant(true), report: Report(
        id: "3",
        user: "user@something.com",
        reportNumber: "RPT789012",
        reportStatus: "Rejected",
        reportSubmitDate: "2023-03-10",
        integrationStatus: "Not Integrated",
        integrationDate: nil,
        reportDate: "2024-06-08",
        expenseType: "Domestic",
        purpose: "Hotel stay during conference",
        paymentMethod: "Debit Card",
        reportAmount: "500.00",
        reportCurrency: "USD",
        createdAt: "2023-03-08T09:00:00Z",
        updatedAt: "2023-03-10T14:00:00Z"
    ), selectedType: .autoRental)
    .environmentObject(AuthenticationManager())
    .environmentObject(MockCommonDataManager())
}
