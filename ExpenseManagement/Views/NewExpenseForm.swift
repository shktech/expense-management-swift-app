import SwiftUI
import PhotosUI
import UIKit

struct NewExpenseForm: View {
    @Binding var isShowingSelf: Bool
    let report: Report
    let countries: [String] = ["USD", "CAD", "JPY"]
    let selectedType: ExpenseType
    @State var selectedCity: String = ""
    @State var date: Date = Date()
    @State var selectedCurrency: String = "USD"
    @State var amount: String = ""
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
    
    var convertedAmount: Double {
        let amountValue = Double(amount) ?? 0
        return Utilities.CurrencyConverter.convert(amount: amountValue, from: selectedCurrency, to: authManager.user?.currency ?? "USD")
    }
    
    var body: some View {
        ZStack {
            Color(uiColor: .systemGray6)
                .ignoresSafeArea()
            content
                .padding()
                .loadingOverlay(isLoading: $isLoading)
        }
        .sheet(isPresented: $isShowingFilePicker) {
            FilePicker(selectedFileURL: $selectedFileURL)
        }
        .sheet(isPresented: $isShowingImagePicker) {
            ImagePicker(selectedFileURL: $selectedFileURL)
        }
        .actionSheet(isPresented: $isShowingActionSheet) {
            ActionSheet(title: Text("Upload Receipt"), message: nil, buttons: [
                .default(Text("Take Photo")) {
                    showImagePicker(sourceType: .camera)
                },
                .default(Text("Photo Library")) {
                    showImagePicker(sourceType: .photoLibrary)
                },
                .default(Text("Browse")) {
                    isShowingFilePicker = true
                },
                .cancel()
            ])
        }
    }
    
    var content: some View {
        ScrollView {
            VStack {
//                ourPfu
//                line
                reportHeader
                line
                dateField
                HStack {
                    VStack {
                        recieptAmountContainer
                        Image(systemName: "arrow.up.arrow.down")
                            .foregroundStyle(.gray)
                            .padding(.top, 2)
                            .padding(.bottom, 2)
                        convertedCurrency
                    }
                }.padding(.bottom, 3)
                if selectedTypeRequiresCity {
                    cityContainer
                }
                specificFields
                justificationContainer
                filePickerButton
                Spacer()
                saveButton
                    .padding(.bottom, 3)
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
        VStack(alignment: .leading, spacing: 2) {
            Text("Airline").foregroundStyle(.gray)
            Menu {
                ForEach(commonDataManager.airlines, id: \.value) { city in
                    Button(action: {
                        selectedCity = city.value
                    }, label: {
                        Text(city.value)
                    })
                }
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray, lineWidth: 1)
                    HStack {
                        Text(selectedCity)
                            .foregroundStyle(.black)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .foregroundStyle(.gray)
                            .fontWeight(.semibold)
                    }.padding(.horizontal)
                }
            }.frame(height: 41)
                        TextField("Origin", text: $origin)
                        TextField("Destination", text: $destination)
        }.padding(.bottom, 3)
    }
    
    var autoRentalFields: some View {
        VStack(alignment: .leading, spacing: 2) {
            Picker("Rental Agency", selection: $rentalAgency) {
                Text("Agency 1").tag("Agency 1")
                Text("Agency 2").tag("Agency 2")
            }
            Picker("Car Type", selection: $carType) {
                Text("SUV").tag("SUV")
                Text("Sedan").tag("Sedan")
            }
        }
    }
    
    var businessMealsFields: some View {
        VStack(alignment: .leading, spacing: 2) {
            Picker("Meal Category", selection: $mealCategory) {
                Text("Lunch").tag("Lunch")
                Text("Dinner").tag("Dinner")
            }
            TextField("Employee Names", text: $employeeNames)
        }
    }
    
    var entertainmentFields: some View {
        VStack(alignment: .leading, spacing: 2) {
            TextField("Name of Establishment", text: $establishmentName)
            TextField("City", text: $selectedCity)
            TextField("Business Topic", text: $businessTopic)
            TextField("Total Attendees", value: $totalAttendees, formatter: NumberFormatter())
            if selectedType == .entertainment {
                Picker("Relationship to PAI", selection: $relationshipToPAI) {
                    Text("Business").tag("Business")
                    Text("Personal").tag("Personal")
                }
            } else {
                TextField("Attendees", text: $employeeNames)
            }
        }
    }
    
    var hotelFields: some View {
        VStack(alignment: .leading, spacing: 2) {
            //            Picker("Hotel Name", selection: $hotelName) {
            //                Text("Hotel 1").tag("Hotel 1")
            //                Text("Hotel 2").tag("Hotel 2")
            //            }
            //            TextField("City", text: $selectedCity)
            Picker("Hotel Daily Base Rate", selection: $hotelDailyBaseRate) {
                Text("Rate 1").tag("Rate 1")
                Text("Rate 2").tag("Rate 2")
            }
        }
    }
    
    var mileageFields: some View {
        VStack(alignment: .leading, spacing: 2) {
            TextField("Origin", text: $origin)
            TextField("Destination", text: $destination)
            TextField("Distance", text: $distance)
            Picker("Mileage Rate", selection: $mileageRate) {
                Text("Rate 1").tag("Rate 1")
                Text("Rate 2").tag("Rate 2")
            }
        }
    }
    
    var telephoneCellFields: some View {
        VStack(alignment: .leading, spacing: 2) {
            TextField("Carrier", text: $carrier)
        }
    }
    
    var filePickerButton: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("Upload Receipt")
                .foregroundStyle(.gray)
            Button(action: {
                isShowingActionSheet.toggle()
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                        .foregroundColor(.gray)
                        .frame(height: 60)
                    VStack {
                        Image(systemName: "square.and.arrow.up")
                            .foregroundStyle(.gray)
                            .fontWeight(.semibold)
                        Text(selectedFileURL?.lastPathComponent ?? "Upload file")
                            .foregroundStyle(.gray)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                }
                .frame(width: 250)
                .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(.bottom, 3)
    }
    
    var ourPfu: some View {
        VStack {
            HStack {
                Spacer()
                Image("pfuLogo")
            }
        }.ignoresSafeArea()
    }
    
    var line: some View {
        RoundedRectangle(cornerRadius: 10)
            .frame(height: 1)
            .foregroundStyle(Color.gray.opacity(0.4))
    }
    
    var reportHeader: some View {
        HStack {
            VStack(alignment: .leading, spacing: 3) {
                Text(report.reportNumber)
                    .font(.system(size: 32).weight(.semibold))
                if let date = DateFormatter.apiDate.date(from: report.reportDate) {
                    Text(DateFormatter.userFriendly.string(from: date))
                        .font(.system(size: 17).weight(.semibold))
                } else {
                    Text("Unknown Date")
                        .font(.system(size: 17).weight(.semibold))
                        .foregroundStyle(.gray)
                }
                Text(report.purpose)
                    .font(.system(size: 17).weight(.semibold))
            }
            Spacer()
        }.padding(.bottom, 3)
    }
    
    var cityContainer: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("City")
                .foregroundStyle(.gray)
            Menu {
                ForEach(commonDataManager.cities, id: \.value) { city in
                    Button(action: {
                        selectedCity = city.value
                    }, label: {
                        Text(city.value)
                    })
                }
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray, lineWidth: 1)
                    HStack {
                        Text(selectedCity)
                            .foregroundStyle(.black)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .foregroundStyle(.gray)
                            .fontWeight(.semibold)
                    }.padding(.horizontal)
                }
            }.frame(height: 41)
        }.padding(.bottom, 3)
    }
    
    var dateField: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Date")
                .foregroundStyle(.gray)
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray, lineWidth: 1)
                    .frame(height: 41)
                HStack {
                    Text("\(date.formatted(date: .numeric, time: .omitted))")
                        .foregroundStyle(.black)
                    Spacer()
                    Image(systemName: "calendar")
                        .font(.title3)
                        .foregroundStyle(.gray)
                        .overlay {
                            DatePicker(
                                "",
                                selection: $date,
                                displayedComponents: [.date]
                            )
                            .blendMode(.destinationOver)
                        }
                }.padding()
            }
        }.padding(.bottom, 3)
    }
    
    var recieptAmountContainer: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("Reciept Amount")
                .foregroundStyle(.gray)
            HStack {
                Menu {
                    ForEach(countries, id: \.self) { currency in
                        Button(action: {
                            selectedCurrency = currency
                        }, label: {
                            Text(currency)
                        })
                    }
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 1)
                        HStack {
                            Image(selectedCurrency)
                            Text(selectedCurrency)
                                .foregroundStyle(.black)
                            Image(systemName: "chevron.down")
                                .foregroundStyle(.gray)
                                .fontWeight(.semibold)
                        }
                    }
                }
                .frame(width: 100)
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray, lineWidth: 1)
                    TextField("", text: $amount)
                        .padding(.horizontal)
                }
            }.frame(height: 41)
        }
    }
    
    var convertedCurrency: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("Converted Reporting Amount")
                .foregroundStyle(.gray)
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray, lineWidth: 1)
                    HStack {
                        Image("USD")
                        Text("USD")
                            .foregroundStyle(.black)
                        Image(systemName: "chevron.down")
                            .foregroundStyle(.gray)
                            .fontWeight(.semibold)
                    }
                }
                .frame(width: 100)
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray, lineWidth: 1)
                    Text("\(convertedAmount.formatted(.number))")
                }
            }.frame(height: 41)
        }.disabled(true)
    }
    
    var justificationContainer: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("Justification")
                .foregroundStyle(.gray)
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray, lineWidth: 1)
                TextField("Justify your expense here", text: $justification)
                    .padding(.horizontal)
            }.frame(height: 41)
            
        }.padding(.bottom, 3)
    }
    
    var saveButton: some View {
        Button(action: {
            submitItem()
        }, label: {
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .foregroundStyle(.blue)
                Text("Save")
                    .foregroundStyle(.white)
                    .font(.system(size: 17).weight(.semibold))
            }
        }).frame(height: 41)
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
}


#Preview {
    NewExpenseForm(isShowingSelf: .constant(true), report: Report(
        id: "3",
        user: (dao.user?.first_name ?? "") + (dao.user?.last_name ?? ""),
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
    ), selectedType: .airFare)
    .environmentObject(AuthenticationManager())
}
