import SwiftUI

struct NewReportView: View {
    
    @Binding var isShowing: Bool
    @State var newReportName: String = "New Report"
    @FocusState private var isTextFieldFocused: Bool
    @FocusState private var isPurposeFieldFocused: Bool
    
    @State var isLoading: Bool = false
    @State var date: Date = Date()
    @State var expenseType: String = ""
    @State var purposeField: String = ""
    @State var selectedPaymentMethod: String = "Cash"
    @State var selectedCurrency: String = "USD"
    
    @EnvironmentObject var authManager: AuthenticationManager
    
    let allCurrency: [String] = [
        "USD", "EUR", "JPY", "CAD"
    ]
    
    var body: some View {
        ZStack {
            Color(uiColor: .systemGray6)
                .ignoresSafeArea()
            ZStack {
                ourPfu
                content.loadingOverlay(isLoading: $isLoading)
            }.padding()
        }
    }
    
    var ourPfu: some View {
        VStack {
            HStack {
                Spacer()
                Image("pfuLogo")
            }
            Spacer()
        }.ignoresSafeArea()
    }
    
    var content: some View {
        VStack {
            headerContent
            line
            newReportNameField
            dateField
            expenseTypeField
            purposeFieldContainer
            preferredPaymentMethodContainer
            currencyField
            Spacer()
            addButton
        }.padding()
    }
    
    var headerContent: some View {
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                Text(authManager.user?.first_name ?? "")
                    .font(.system(size: 17).weight(.semibold))
                Text(authManager.user?.department ?? "")
                    .font(.system(size: 17).weight(.semibold))
                    .foregroundStyle(Color.black.opacity(0.5))
            }
            .padding(.bottom)
            Spacer()
        }
    }
    
    var line: some View {
        RoundedRectangle(cornerRadius: 10)
            .frame(height: 1)
            .foregroundStyle(Color.gray.opacity(0.4))
    }
    
    var newReportNameField: some View {
        HStack {
            TextField("New Report", text: $newReportName)
                .focused($isTextFieldFocused)
                .font(.system(size: 32).weight(.semibold))
            Spacer()
        }.padding(.top)
        .onAppear {
            isTextFieldFocused = true
        }
    }
    
    var dateField: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Date")
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray, lineWidth: 2)
                    .frame(height: 41)
                HStack {
                    Text("\(date.formatted(date: .numeric, time: .omitted))")
                    Spacer()
                    Image(systemName: "calendar")
                        .font(.title3)
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
    
    var expenseTypeField: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Expense Type")
            Menu {
                Button(action: {
                    expenseType = "Domestic"
                }, label: {
                    Text("Domestic")
                })
                Button(action: {
                    expenseType = "International"
                }, label: {
                    Text("International")
                })
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray, lineWidth: 2)
                        .frame(height: 41)
                        .foregroundStyle(Color(uiColor: .systemGray6))
                    HStack {
                        Text(expenseType)
                            .foregroundStyle(Color.black)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .foregroundStyle(Color.gray)
                    }.padding()
                }
            }
        }.padding(.top)
    }
    
    var purposeFieldContainer: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Purpose")
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray, lineWidth: 2)
                    .frame(height: 41)
                TextField("ex: New Conference", text: $purposeField)
                    .focused($isPurposeFieldFocused)
                    .padding()
            }
        }.padding(.top)
        .onAppear {
            isPurposeFieldFocused = true
        }
    }
    
    var preferredPaymentMethodContainer: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Preferred Payment Method")
            Menu {
                Button(action: {
                    selectedPaymentMethod = "Cash"
                }, label: {
                    Text("Cash")
                })
                Button(action: {
                    selectedPaymentMethod = "Credit card"
                }, label: {
                    Text("Credit card")
                })
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray, lineWidth: 2)
                        .frame(height: 41)
                        .foregroundStyle(Color(uiColor: .systemGray6))
                    HStack {
                        Text(selectedPaymentMethod)
                            .foregroundStyle(Color.black)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .foregroundStyle(Color.gray)
                    }.padding()
                }
            }
        }.padding(.top)
    }
    
    var currencyField: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Currency")
            Menu {
                ForEach(allCurrency, id: \.self) { currency in
                    Button(action: {
                        selectedCurrency = currency
                    }, label: {
                        Text(currency)
                    })
                }
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray, lineWidth: 2)
                        .frame(height: 41)
                        .foregroundStyle(Color(uiColor: .systemGray6))
                    HStack {
                        Text(selectedCurrency)
                            .foregroundStyle(Color.black)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .foregroundStyle(Color.gray)
                    }.padding()
                }
            }
        }
    }
    
    var addButton: some View {
        Button(action: {
            isLoading = true
            submitReport()
        }, label: {
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .foregroundStyle(.blue)
                Text("Add")
                    .foregroundStyle(.white)
                    .font(.system(size: 17).weight(.semibold))
                    
            }
        }).frame(height: 41)
    }
    
    func submitReport() {
        guard let accessToken = authManager.accessToken else {
            print("Access token not found")
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let formattedDate = dateFormatter.string(from: date)
        
        let newReport = CreateReportRequest(
            reportDate: formattedDate,
            expenseType: expenseType,
            purpose: purposeField,
            paymentMethod: selectedPaymentMethod,
            reportAmount: 0,
            reportCurrency: selectedCurrency
        )
        
        print(newReport)
        
        dao.createReport(reportData: newReport, accessToken: accessToken) { result in
            switch result {
            case .success(let createdReport):
                print("Created report: \(createdReport)")
                isLoading = false
                isShowing.toggle()
            case .failure(let error):
                print("Failed to create report: \(error.localizedDescription)")
                isLoading = false
            }
        }
    }
}
