import SwiftUI
import PhotosUI
import UIKit

struct NewExpenseForm: View {
    @Binding var isShowingSelf: Bool
    let report: Report
    let countries: [String] = ["USD", "CAD", "JPY"]
    @State var selectedType: ExpenseType?
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
                ourPfu
                line
                reportHeader
                expenseTypeContainer
                cityContainer
                dateField
                HStack {
                    VStack {
                        recieptAmountContainer
                        convertedCurrency
                    }
                    Image(systemName: "arrow.up.arrow.down")
                        .foregroundStyle(.gray)
                        .padding(.top)
                }
                justificationContainer
                filePickerButton
                Spacer()
                saveButton
                    .padding(.top)
            }.padding()
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
        .padding(.top)
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
        }
    }
    
    var expenseTypeContainer: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("Expense Type")
                .foregroundStyle(.gray)
            Menu {
                ForEach(ExpenseType.allCases) { type in
                    Button(action: {
                        selectedType = type
                    }, label: {
                        Text(type.displayName)
                    })
                }
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray, lineWidth: 1)
                    HStack {
                        Text("\(selectedType?.displayName ?? "")")
                            .foregroundStyle(.black)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .foregroundStyle(.gray)
                            .fontWeight(.semibold)
                    }.padding(.horizontal)
                }
            }.frame(height: 41)
        }.padding(.top)
    }
    
    var cityContainer: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("City")
                .foregroundStyle(.gray)
            Menu {
                ForEach(commonDataManager.cities, id: \.value) {city in
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
            
        }.padding(.top)
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
        }.padding(.top)
    }
    
    var recieptAmountContainer: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("Reciept Amount")
                .foregroundStyle(.gray)
            HStack {
                Menu {
                    ForEach(countries, id:\.self) { currency in
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
        .padding(.top)
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
        }
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
            
        }.padding(.top)
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
        
        guard let selectedType = selectedType else {
            print("Expense type not selected")
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
            justification: justification,
            note: "N/A",
            fileName: fileName
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
}
