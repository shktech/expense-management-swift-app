import SwiftUI
import FormValidator

struct NewReportView: View {
    
    @Binding var isShowing: Bool
    @State var newReportName: String = "New Report"
    @FocusState private var isPurposeFieldFocused: Bool
    
    @State var isLoading: Bool = false
    @State var date: Date = Date()
    @State var expenseType: String = ""
    @State var purposeField: String = ""
    @State var selectedPaymentMethod: String = "Cash"
    @State var selectedCurrency: String = "USD"
    @State var isEditable: Bool = true
    
    @EnvironmentObject var authManager: AuthenticationManager
    private let dao = DAO.instance
    
    @ObservedObject var form = FormValidatorManager()
    
    @State private var isPurposeFocused: Bool = false
    @State private var isDefaultCurrencyFocused: Bool = false
    
    var body: some View {
        ZStack {
            ZStack {
                content
            }.padding()
        }.loadingOverlay(isLoading: $isLoading)
    }
    
    var content: some View {
        VStack(spacing: 20) {
            newReportNameField.padding(.vertical)
            DateFieldView(title: "Date", date: $date, isEditable: .constant(true))
            PickerField(title: "Report Type", options: ["Domestic", "International"], selectedOption: $expenseType, isEditable: .constant(true))
            TextInputView(title: "Purpose", text: $purposeField, isEditable: .constant(true), validation: form.purposeValidation, placeholder: "ex: New Conference", isFocused: $isPurposeFocused)
                .focused($isPurposeFieldFocused)
                .onAppear {
                    isPurposeFieldFocused = true
                }
            PickerField(title: "Preferred Payment Method", options: ["Cash", "Credit card"], selectedOption: $selectedPaymentMethod, isEditable: .constant(true))
            CurrencyPicker(selectedCurrency: $selectedCurrency, isEditable: .constant(true), title: "Default Concurrency", isFocused: $isDefaultCurrencyFocused)
            Spacer()
            addButton
        }.padding()
        .onChange(of: purposeField) { newValue in
            form.updatePurpose(newValue)
        }
        .onChange(of: expenseType) { newValue in
            form.updateReportType(newValue)
        }
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
            Text(newReportName)
                .font(.system(size: 32).weight(.semibold))
            Spacer()
        }.padding(.top)
    }
    
    var addButton: some View {
        Button(action: {
            isLoading = true
            submitReport()
        }, label: {
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .foregroundStyle(.oceanBlue)
                Text("Save")
                    .foregroundStyle(.white)
                    .font(Font.custom("Poppins", size: 18).weight(.semibold))
            }
            .opacity((expenseType != "" && purposeField != "") ? 1 : 0.5)
        }).frame(height: 50)
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

#Preview {
    NewReportView(isShowing: .constant(true))
        .environmentObject(AuthenticationManager())
}
