import SwiftUI
import PhotosUI
import UIKit

struct EditExpenseForm: View {
    let report: Report
    let countries: [String] = ["USD", "CAD", "JPY"]
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
    
    // Editting fields
    var expenseReport: ExpenseItem

    @State var isEditable: Bool = false
    
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
    
    var warningMessage: String? {
        switch expenseReport.expenseType {
        case "airlineClubMembershipDues":
            return "Approved Requisition is required for this expense type. Enter Requisition number in Justification Field"
        case "autoRental", "automobile":
            return "Approved Requisition is required for this expense type. Enter Requisition number in Justification Field"
        case "companySponsorVPDF":
            return "Pre-approval required, include approved form with receipts"
        case "customerGifts":
            return "Pre-approval required, include approved form with receipts"
        case "dataProcessingDisksManual":
            return "Pre-approval required, include approved form with receipts"
        case "entertainment", "entertainmentLevi":
            return "Approved Requisition is required for this expense type. Enter Requisition number in Justification Field"
        case "fieldEngineerSupplies":
            return "Approved Requisition is required for this expense type. Enter Requisition number in Justification Field"
        case "officeSupplies":
            return "Must include approved Purchase Requisition number"
        case "otherMarketingExpenses":
            return "Approved Requisition is required for this expense type. Enter Requisition number in Justification Field"
        case "seminarsTraining":
            return "Must include approved ETA number. Enter ETA number in Justification field"
        case "marketingDevelopment":
            return "Approved Requisition is required for this expense type. Enter Requisition number in Justification Field"
        default:
            return nil
        }
    }

    var body: some View {
        ZStack {
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
                        Image(systemName: isEditable ? "pencil.slash" : "pencil.circle.fill")
                            .font(.title)
                            .foregroundStyle(.oceanBlue)
                    }
                }
                if let warningMessage = warningMessage {
                    Text(warningMessage)
                        .foregroundColor(.red)
                        .font(Font.custom("Poppins", size: 17).weight(.semibold))
                        .multilineTextAlignment(.center)
                }
                dateField
                specificFields
                allAmmounts
                if selectedTypeRequiresCity {
                    cityContainer
                }
                justificationContainer
                filePickerButton
                Spacer()
                saveButton
            }.padding()
        }
    }
    
    var specificFields: some View {
        Group {
            switch expenseReport.expenseType {
            case "airFare":
                airFareFields
            case "autoRental":
                autoRentalFields
            case "businessMeals":
                businessMealsFields
            case "entertainment", "entertainmentLevi":
                entertainmentFields
            case "hotel":
                hotelFields
            case "mileage":
                mileageFields
            case "telephoneCell":
                telephoneCellFields
            default:
                EmptyView()
            }
        }
    }
    
    var airFareFields: some View {
        VStack(alignment: .leading, spacing: 15) {
            VStack(alignment: .leading, spacing: 3) {
                Text("Airline")
                    .font(Font.custom("Poppins", size: 16).weight(.semibold))
                    .foregroundStyle(.oceanBlue)
                NavigationLink(destination: AirlinePickerView(selectedAirline: $airline)) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundStyle(.ourLightGray)
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.oceanBlue, lineWidth: 1)
                        HStack {
                            Text(airline == "" ? "Select your Airline" : airline)
                                .foregroundStyle(airline == "" ? .gray : .oceanBlue)
                                .font(Font.custom("Poppins", size: 16).weight(airline == "" ? .regular : .semibold))
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundStyle(.oceanBlue)
                                .fontWeight(.semibold)
                        }.padding(.horizontal)
                        if !isEditable {
                            RoundedRectangle(cornerRadius: 8)
                                .foregroundStyle(.black)
                                .opacity(0.15)
                        }
                    }
                }.frame(height: 41)
                .disabled(!isEditable)
            }
            
            VStack(alignment: .leading, spacing: 3) {
                Text("Origin")
                    .font(Font.custom("Poppins", size: 16).weight(.semibold))
                    .foregroundStyle(.oceanBlue)
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundStyle(.ourLightGray)
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(.oceanBlue, lineWidth: 1)
                    HStack {
                        TextField("---", text: $origin)
                            .font(Font.custom("Poppins", size: 16).weight(.semibold))
                            .foregroundStyle(.oceanBlue)
                    }.padding(.horizontal)
                        .frame(height: 41)
                    if !isEditable {
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundStyle(.black)
                            .opacity(0.15)
                    }
                }
                .disabled(!isEditable)
            }
            VStack(alignment: .leading, spacing: 3) {
                Text("Destination")
                    .font(Font.custom("Poppins", size: 16).weight(.semibold))
                    .foregroundStyle(.oceanBlue)
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundStyle(.ourLightGray)
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(.oceanBlue, lineWidth: 1)
                    HStack {
                        TextField("---", text: $destination)
                            .font(Font.custom("Poppins", size: 16).weight(.semibold))
                            .foregroundStyle(.oceanBlue)
                    }.padding(.horizontal)
                        .frame(height: 41)
                    if !isEditable {
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundStyle(.black)
                            .opacity(0.15)
                    }
                }
                .disabled(!isEditable)
            }
        }
    }
    
    var autoRentalFields: some View {
        VStack(alignment: .leading, spacing: 10) {
            NavigationLink(destination: CarRentalPickerView(selectedRental: $rentalAgency)) {
                VStack(alignment: .leading, spacing: 3) {
                    Text("Rental Agency")
                        .font(Font.custom("Poppins", size: 16).weight(.semibold))
                        .foregroundStyle(.oceanBlue)
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundStyle(.ourLightGray)
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(.oceanBlue, lineWidth: 1)
                        HStack {
                            Text(rentalAgency == "" ? "---" : rentalAgency)
                                .foregroundStyle(rentalAgency == "" ? .gray : .oceanBlue)
                                .font(Font.custom("Poppins", size: 16))
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundStyle(.oceanBlue)
                                .fontWeight(.semibold)
                        }.padding(.horizontal)
                        if !isEditable {
                            RoundedRectangle(cornerRadius: 8)
                                .foregroundStyle(.black)
                                .opacity(0.15)
                        }
                    }
                    .frame(height: 41)
                }
            }
            .disabled(!isEditable)
            NavigationLink(destination: CarTypesPickerView(selectedCar: $carType)) {
                VStack(alignment: .leading, spacing: 3) {
                    Text("Car Type")
                        .font(Font.custom("Poppins", size: 16).weight(.semibold))
                        .foregroundStyle(.oceanBlue)
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundStyle(.ourLightGray)
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(.oceanBlue, lineWidth: 1)
                        HStack {
                            Text(carType == "" ? "---" : carType)
                                .foregroundStyle(carType == "" ? .gray : .oceanBlue)
                                .font(Font.custom("Poppins", size: 16))
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundStyle(.oceanBlue)
                                .fontWeight(.semibold)
                        }.padding(.horizontal)
                        if !isEditable {
                            RoundedRectangle(cornerRadius: 8)
                                .foregroundStyle(.black)
                                .opacity(0.15)
                        }
                    }
                    .frame(height: 41)
                }
            }
            .disabled(!isEditable)
        }
    }
    
    var businessMealsFields: some View {
        NavigationLink(destination: MealCategoriesPickerView(selectedMeal: $mealCategory)) {
            VStack(alignment: .leading, spacing: 3) {
                Text("Meal Category")
                    .font(Font.custom("Poppins", size: 16).weight(.semibold))
                    .foregroundStyle(.oceanBlue)
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundStyle(.ourLightGray)
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(.oceanBlue, lineWidth: 1)
                    HStack {
                        Text(mealCategory == "" ? "---" : mealCategory)
                            .foregroundStyle(mealCategory == "" ? .gray : .oceanBlue)
                            .font(Font.custom("Poppins", size: 16))
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundStyle(.oceanBlue)
                            .fontWeight(.semibold)
                    }.padding(.horizontal)
                    if !isEditable {
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundStyle(.black)
                            .opacity(0.15)
                    }
                }
                .frame(height: 41)
            }
        }
        .disabled(!isEditable)
    }
    
    var entertainmentFields: some View {
        VStack(alignment: .leading, spacing: 10) {
            VStack(alignment: .leading, spacing: 3) {
                Text("Name of Establishment")
                    .font(Font.custom("Poppins", size: 16).weight(.semibold))
                    .foregroundStyle(.oceanBlue)
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundStyle(.ourLightGray)
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(.oceanBlue, lineWidth: 1)
                    HStack {
                        TextField("---", text: $establishmentName)
                            .font(Font.custom("Poppins", size: 16).weight(.semibold))
                            .foregroundStyle(.oceanBlue)
                    }.padding(.horizontal)
                    if !isEditable {
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundStyle(.black)
                            .opacity(0.15)
                    }
                }.frame(height: 41)
                .disabled(!isEditable)
            }
            VStack(alignment: .leading, spacing: 3) {
                Text("City")
                    .font(Font.custom("Poppins", size: 16).weight(.semibold))
                    .foregroundStyle(.oceanBlue)
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundStyle(.ourLightGray)
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(.oceanBlue, lineWidth: 1)
                    HStack {
                        TextField("---", text: $selectedCity)
                            .font(Font.custom("Poppins", size: 16).weight(.semibold))
                            .foregroundStyle(.oceanBlue)
                    }.padding(.horizontal)
                    if !isEditable {
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundStyle(.black)
                            .opacity(0.15)
                    }
                }.frame(height: 41)
                .disabled(!isEditable)
            }
            VStack(alignment: .leading, spacing: 3) {
                Text("Business Topic")
                    .font(Font.custom("Poppins", size: 16).weight(.semibold))
                    .foregroundStyle(.oceanBlue)
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundStyle(.ourLightGray)
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(.oceanBlue, lineWidth: 1)
                    HStack {
                        TextField("---", text: $businessTopic)
                            .font(Font.custom("Poppins", size: 16).weight(.semibold))
                            .foregroundStyle(.oceanBlue)
                    }.padding(.horizontal)
                    if !isEditable {
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundStyle(.black)
                            .opacity(0.15)
                    }
                }.frame(height: 41)
                .disabled(!isEditable)
            }
            VStack(alignment: .leading, spacing: 3) {
                Text("Total Attendees")
                    .font(Font.custom("Poppins", size: 16).weight(.semibold))
                    .foregroundStyle(.oceanBlue)
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundStyle(.ourLightGray)
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(.oceanBlue, lineWidth: 1)
                    HStack {
                        TextField("---", value: $totalAttendees, formatter: NumberFormatter())
                            .font(Font.custom("Poppins", size: 16).weight(.semibold))
                            .foregroundStyle(.oceanBlue)
                    }.padding(.horizontal)
                    if !isEditable {
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundStyle(.black)
                            .opacity(0.15)
                    }
                }.frame(height: 41)
                .disabled(!isEditable)
            }
            if expenseReport.expenseType == "entertainment" {
                NavigationLink(destination: RelashionshipToPaiPickerView(selectedRelation: $relationshipToPAI)) {
                    VStack(alignment: .leading, spacing: 3) {
                        Text("Relationship to PAI")
                            .font(Font.custom("Poppins", size: 16).weight(.semibold))
                            .foregroundStyle(.oceanBlue)
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .foregroundStyle(.ourLightGray)
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(.oceanBlue, lineWidth: 1)
                            HStack {
                                Text(mealCategory == "" ? "---" : mealCategory)
                                    .foregroundStyle(mealCategory == "" ? .gray : .oceanBlue)
                                    .font(Font.custom("Poppins", size: 16))
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundStyle(.oceanBlue)
                                    .fontWeight(.semibold)
                            }.padding(.horizontal)
                            if !isEditable {
                                RoundedRectangle(cornerRadius: 8)
                                    .foregroundStyle(.black)
                                    .opacity(0.15)
                            }
                        }
                        .frame(height: 41)
                    }
                }
                .disabled(!isEditable)
            } else {
                VStack(alignment: .leading, spacing: 3) {
                    Text("Attendees (Names)")
                        .font(Font.custom("Poppins", size: 16).weight(.semibold))
                        .foregroundStyle(.oceanBlue)
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundStyle(.ourLightGray)
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(.oceanBlue, lineWidth: 1)
                        HStack {
                            TextField("---", text: $employeeNames)
                                .font(Font.custom("Poppins", size: 16).weight(.semibold))
                                .foregroundStyle(.oceanBlue)
                        }.padding(.horizontal)
                        if !isEditable {
                            RoundedRectangle(cornerRadius: 8)
                                .foregroundStyle(.black)
                                .opacity(0.15)
                        }
                    }.frame(height: 41)
                    .disabled(!isEditable)
                }
            }
        }
    }
    
    var hotelFields: some View {
        VStack(alignment: .leading, spacing: 10) {
            VStack(alignment: .leading, spacing: 3) {
                Text("Hotel Name")
                    .font(Font.custom("Poppins", size: 16).weight(.semibold))
                    .foregroundStyle(.oceanBlue)
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundStyle(.ourLightGray)
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(.oceanBlue, lineWidth: 1)
                    HStack {
                        TextField("---", text: $hotelName)
                            .font(Font.custom("Poppins", size: 16).weight(.semibold))
                            .foregroundStyle(.oceanBlue)
                    }.padding(.horizontal)
                    if !isEditable {
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundStyle(.black)
                            .opacity(0.15)
                    }
                }.frame(height: 41)
                .disabled(!isEditable)
            }
        }
    }
    
    var mileageFields: some View {
        VStack(alignment: .leading, spacing: 10) {
            VStack(alignment: .leading, spacing: 3) {
                Text("Origin")
                    .font(Font.custom("Poppins", size: 16).weight(.semibold))
                    .foregroundStyle(.oceanBlue)
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundStyle(.ourLightGray)
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(.oceanBlue, lineWidth: 1)
                    HStack {
                        TextField("---", text: $origin)
                            .font(Font.custom("Poppins", size: 16).weight(.semibold))
                            .foregroundStyle(.oceanBlue)
                    }.padding(.horizontal)
                    if !isEditable {
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundStyle(.black)
                            .opacity(0.15)
                    }
                }.frame(height: 41)
                .disabled(!isEditable)
            }
            VStack(alignment: .leading, spacing: 3) {
                Text("Destination")
                    .font(Font.custom("Poppins", size: 16).weight(.semibold))
                    .foregroundStyle(.oceanBlue)
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundStyle(.ourLightGray)
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(.oceanBlue, lineWidth: 1)
                    HStack {
                        TextField("---", text: $destination)
                            .font(Font.custom("Poppins", size: 16).weight(.semibold))
                            .foregroundStyle(.oceanBlue)
                    }.padding(.horizontal)
                    if !isEditable {
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundStyle(.black)
                            .opacity(0.15)
                    }
                }.frame(height: 41)
                .disabled(!isEditable)
            }
            VStack(alignment: .leading, spacing: 3) {
                Text("Distance")
                    .font(Font.custom("Poppins", size: 16).weight(.semibold))
                    .foregroundStyle(.oceanBlue)
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundStyle(.ourLightGray)
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(.oceanBlue, lineWidth: 1)
                    HStack {
                        TextField("---", text: $distance)
                            .font(Font.custom("Poppins", size: 16).weight(.semibold))
                            .foregroundStyle(.oceanBlue)
                    }.padding(.horizontal)
                    if !isEditable {
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundStyle(.black)
                            .opacity(0.15)
                    }
                }.frame(height: 41)
                .disabled(!isEditable)
            }
            NavigationLink(destination: MileageRatePickerView(selectedMileage: $mileageRate)) {
                VStack(alignment: .leading, spacing: 3) {
                    Text("Mileage Rate")
                        .font(Font.custom("Poppins", size: 16).weight(.semibold))
                        .foregroundStyle(.oceanBlue)
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundStyle(.ourLightGray)
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(.oceanBlue, lineWidth: 1)
                        HStack {
                            Text(mileageRate == "" ? "---" : mileageRate)
                                .foregroundStyle(mileageRate == "" ? .gray : .oceanBlue)
                                .font(Font.custom("Poppins", size: 16))
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundStyle(.oceanBlue)
                                .fontWeight(.semibold)
                        }.padding(.horizontal)
                        if !isEditable {
                            RoundedRectangle(cornerRadius: 8)
                                .foregroundStyle(.black)
                                .opacity(0.15)
                        }
                    }
                    .frame(height: 41)
                }
            }
            .disabled(!isEditable)
        }
    }
    
    var telephoneCellFields: some View {
        VStack(alignment: .leading, spacing: 2) {
            VStack(alignment: .leading, spacing: 3) {
                Text("Carrier")
                    .font(Font.custom("Poppins", size: 16).weight(.semibold))
                    .foregroundStyle(.oceanBlue)
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundStyle(.ourLightGray)
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(.oceanBlue, lineWidth: 1)
                    HStack {
                        TextField("---", text: $carrier)
                            .font(Font.custom("Poppins", size: 16).weight(.semibold))
                            .foregroundStyle(.oceanBlue)
                    }.padding(.horizontal)
                    if !isEditable {
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundStyle(.black)
                            .opacity(0.15)
                    }
                }.frame(height: 41)
                .disabled(!isEditable)
            }
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
            .disabled(!isEditable)
        }
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
    
    var cityContainer: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text("City")
                .font(Font.custom("Poppins", size: 16).weight(.semibold))
                .foregroundStyle(.oceanBlue)
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
                        .foregroundStyle(.ourLightGray2)
                        .frame(height: 41)
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(.oceanBlue, lineWidth: 1)
                        .frame(height: 41)
                    HStack {
                        Text(selectedCity)
                            .font(Font.custom("Poppins", size: 16).weight(.semibold))
                            .foregroundStyle(.oceanBlue)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .foregroundStyle(.oceanBlue)
                            .fontWeight(.semibold)
                    }.padding(.horizontal)
                    if !isEditable {
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundStyle(.black)
                            .opacity(0.15)
                    }
                }
            }.frame(height: 41)
            .disabled(!isEditable)
        }
    }
    
    var dateField: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text("Date")
                .font(Font.custom("Poppins", size: 16).weight(.semibold))
                .foregroundStyle(.oceanBlue)
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .foregroundStyle(.ourLightGray2)
                    .frame(height: 41)
                RoundedRectangle(cornerRadius: 8)
                    .stroke(.oceanBlue, lineWidth: 1)
                    .frame(height: 41)
                HStack {
                    Text("\(date.formatted(date: .abbreviated, time: .omitted))")
                        .font(Font.custom("Poppins", size: 16).weight(.semibold))
                        .foregroundStyle(.oceanBlue)
                    Spacer()
                    Image(systemName: "calendar")
                        .font(.title3)
                        .foregroundStyle(.oceanBlue)
                        .overlay {
                            DatePicker(
                                "",
                                selection: $date,
                                displayedComponents: [.date]
                            )
                            .blendMode(.destinationOver)
                        }
                }.padding(.horizontal)
                if !isEditable {
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundStyle(.black)
                        .opacity(0.15)
                }
            }
            .disabled(!isEditable)
        }
    }
    
    var allAmmounts: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(.ourLightBlue)
            RoundedRectangle(cornerRadius: 10)
                .stroke(.oceanBlue, lineWidth: 1)
            VStack {
                recieptAmountContainer
                convertedCurrency
            }.padding()
        }
    }
    
    var recieptAmountContainer: some View {
            VStack(alignment: .leading, spacing: 2) {
                Text("Reciept Amount")
                    .foregroundStyle(.oceanBlue)
                    .font(Font.custom("Poppins", size: 16).weight(.semibold))
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
                                .foregroundStyle(.ourLightGray)
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.oceanBlue, lineWidth: 1)
                            HStack {
                                Image(selectedCurrency)
                                Text(selectedCurrency)
                                    .foregroundStyle(.oceanBlue)
                                    .fontWeight(.semibold)
                                Image(systemName: "chevron.down")
                                    .foregroundStyle(.oceanBlue)
                                    .fontWeight(.semibold)
                            }
                            if !isEditable {
                                RoundedRectangle(cornerRadius: 8)
                                    .foregroundStyle(.black)
                                    .opacity(0.15)
                            }
                        }
                    }
                    .frame(width: 100)
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundStyle(.ourLightGray)
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.oceanBlue, lineWidth: 1)
                        TextField("", text: $amount)
                            .padding(.horizontal)
                        if !isEditable {
                            RoundedRectangle(cornerRadius: 8)
                                .foregroundStyle(.black)
                                .opacity(0.15)
                        }
                    }
                }.frame(height: 41)
                .disabled(!isEditable)
            }
    }
    
    var convertedCurrency: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("Converted Report Amount")
                .foregroundStyle(.oceanBlue)
                .font(Font.custom("Poppins", size: 16).weight(.semibold))
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundStyle(.ourLightGray)
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.oceanBlue, lineWidth: 1)
                    HStack {
                        Image("USD")
                        Text("USD")
                            .foregroundStyle(.oceanBlue)
                            .fontWeight(.semibold)
                        Image(systemName: "chevron.down")
                            .foregroundStyle(.oceanBlue)
                            .fontWeight(.semibold)
                    }
                    if !isEditable {
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundStyle(.black)
                            .opacity(0.15)
                    }
                }
                .frame(width: 100)
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundStyle(.ourLightGray)
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.oceanBlue, lineWidth: 1)
                    Text("\(convertedAmount.formatted(.number))")
                        .foregroundStyle(.oceanBlue)
                        .fontWeight(.semibold)
                    if !isEditable {
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundStyle(.black)
                            .opacity(0.15)
                    }
                }
            }.frame(height: 41)
        }.disabled(true)
    }
    
    var justificationContainer: some View {
        VStack(alignment: .leading, spacing: 2) {
            VStack(alignment: .leading, spacing: 3) {
                Text("Justification")
                    .font(Font.custom("Poppins", size: 16).weight(.semibold))
                    .foregroundStyle(.oceanBlue)
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundStyle(.ourLightGray)
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(.oceanBlue, lineWidth: 1)
                    HStack {
                        TextField("---", text: $justification)
                            .font(Font.custom("Poppins", size: 16).weight(.semibold))
                            .foregroundStyle(.oceanBlue)
                    }.padding(.horizontal)
                    if !isEditable {
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundStyle(.black)
                            .opacity(0.15)
                    }
                }.frame(height: 41)
                .disabled(!isEditable)
            }
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
        }).frame(height: 41)
        .disabled(!isEditable)
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
            expenseType: expenseReport.expenseType,
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
        switch expenseReport.expenseType {
        case "entertainment", "entertainmentLevi", "hotel":
            return true
        default:
            return false
        }
    }
    
    private func loadExpenseData() {
        self.selectedCity = expenseReport.city ?? ""
        self.date = DateFormatter.apiDate.date(from: expenseReport.expenseDate) ?? Date()
        self.selectedCurrency = expenseReport.receiptCurrency
        self.amount = expenseReport.receiptAmount
        self.justification = expenseReport.justification
        self.airline = expenseReport.airline ?? ""
        self.origin = expenseReport.originDestination ?? ""
        self.rentalAgency = expenseReport.rentalAgency ?? ""
        self.carType = expenseReport.carType ?? ""
        self.mealCategory = expenseReport.mealCategory ?? ""
        self.employeeNames = expenseReport.employeeNames ?? ""
        self.establishmentName = expenseReport.nameOfEstablishment ?? ""
        self.businessTopic = expenseReport.businessTopic ?? ""
        self.totalAttendees = expenseReport.totalAttendees ?? 0
        self.relationshipToPAI = expenseReport.relationshipToPAI ?? ""
        self.hotelName = expenseReport.hotelName ?? ""
        self.hotelDailyBaseRate = expenseReport.hotelDailyBaseRate ?? ""
        self.distance = expenseReport.distance ?? ""
        self.mileageRate = expenseReport.mileageRate ?? ""
        self.carrier = expenseReport.carrier ?? ""
        self.companyCustomerName = expenseReport.companyCustomerName ?? ""
    }
}

#Preview {
    EditExpenseForm(report: Report(
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
    ), expenseReport: ExpenseItem(
        id: "1",
        airline: "Delta",
        rentalAgency: "Hertz",
        carType: "SUV",
        mealCategory: "Lunch",
        relationshipToPAI: "Business",
        city: "New York",
        hotelDailyBaseRate: "200",
        mileageRate: "0.58",
        presignedURL: nil,
        filename: "receipt.pdf",
        expenseType: "hotel",
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
}


#Preview {
    EditExpenseForm(report: Report(
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
    ), expenseReport: ExpenseItem(
        id: nil,
        airline: nil,
        rentalAgency: nil,
        carType: nil,
        mealCategory: nil,
        relationshipToPAI: nil,
        city: nil,
        hotelDailyBaseRate: nil,
        mileageRate: nil,
        presignedURL: nil,
        filename: nil,
        expenseType: "Airline",
        expenseDate: "2024-06-24",
        receiptAmount: "120.99",
        receiptCurrency: "USD",
        justification: "Travel to Brazil",
        note: nil,
        s3Path: nil,
        originDestination: nil,
        employeeNames: nil,
        totalEmployees: nil,
        companyCustomerName: nil,
        businessTopic: nil,
        totalAttendees: nil,
        nameOfEstablishment: nil,
        hotelName: nil,
        carrier: nil,
        distance: nil,
        createdAt: nil,
        updatedAt: nil,
        report: nil
    ))
    .environmentObject(AuthenticationManager())
}
