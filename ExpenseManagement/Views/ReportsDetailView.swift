import SwiftUI

struct ReportsDetailView: View {
    
    @Binding var report: Report
    
    @State var isShowingForm: Bool = false
    @State var isShowingDeleteConfirmation: Bool = false
    @State var isShowingSubmitConfirmation: Bool = false
    @State var isLoading: Bool = false
    @State var expenseItems: [ExpenseItem] = []
    
    @EnvironmentObject var authManager: AuthenticationManager
    @EnvironmentObject var globalState: GlobalStateManager
    
    private let dao = DAO.instance
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.white
                    .ignoresSafeArea()
                VStack {
                    content
                    if (report.reportStatus == "Open" && !expenseItems.isEmpty) {
                        submittingButton
                    }
                }
                .padding(.horizontal)
                .toolbar {
                    if (report.reportStatus == "Open") {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button {
                                isShowingForm.toggle()
                            } label: {
                                Image(systemName: "plus")
                                    .foregroundColor(.oceanBlue)
                            }
                        }
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button {
                                isShowingDeleteConfirmation.toggle()
                            } label: {
                                Image(systemName: "trash")
                                    .foregroundColor(.oceanBlue)
                            }
                            .confirmationDialog("Delete Report",
                                                isPresented: $isShowingDeleteConfirmation, titleVisibility: .visible) {
                                Button("Delete", role: .destructive) {}
                            } message: {
                                Text("Are you sure you want to delete this report")
                            }
                        }
                    }
                }
                .sheet(isPresented: $isShowingForm, content: {
                    SelectTypeForm(isShowingSelf: $isShowingForm, report: report)
                })
                .onChange(of: isShowingForm) { _ in
                    if !isShowingForm {
                        refreshReport()
                    }
                    loadData()
                }
                .onAppear(perform: loadData)
                .loadingOverlay(isLoading: $isLoading)
            }
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
            reportHeader
            if (report.reportStatus != "Open") {
                TimeLineContentView(status: report.reportStatus)
            }
            if (expenseItems.isEmpty) {
                ContentUnavailableView(title: "No expenses", description: "Tap the “+“ button and start adding expenses")
            } else {
                expenseItemsList
            }
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
    
    var reportHeader: some View {
        HStack {
            VStack(alignment: .leading, spacing: 3) {
                VStack(alignment: .leading, spacing: 0) {
                    Text(report.reportNumber)
                        .font(Font.custom("Nunito", size: 32).weight(.semibold))
                        .foregroundStyle(.ourDarkGray)
                    if let date = DateFormatter.apiDate.date(from: report.reportDate) {
                        Text(DateFormatter.userFriendly.string(from: date))
                            .font(Font.custom("Poppins", size: 17).weight(.semibold))
                            .foregroundStyle(.gray)
                    }
                }
                Text(report.purpose)
                    .font(Font.custom("Nunito", size: 18).weight(.semibold))
                    .foregroundStyle(.ourDarkGray)
                Text("\(Utilities.CurrencyFormatter.formatCurrency(amount: report.reportAmount, currencyCode: report.reportCurrency))")
                    .font(Font.custom("Nunito", size: 18).weight(.bold))
                    .foregroundStyle(.oceanBlue)
            }
            Spacer()
        }
    }
    
    var expenseItemsList: some View {
        VStack {
            ScrollView {
                ForEach(expenseItems, id:\.id) { expenseItem in
                    ExpenseComponent(expense: expenseItem, report: report)
                        .frame(height: 86)
                        .padding(.vertical, 7)
                        .padding(.horizontal, 1)
                }
            }
        }.padding(.top)
    }
    
    var submittingButton: some View {
        Button(action: {
            isShowingSubmitConfirmation.toggle()
        }, label: {
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .foregroundStyle(.oceanBlue)
                Text("Submit")
                    .foregroundStyle(.white)
                    .font(Font.custom("Poppins", size: 18).weight(.semibold))
            }
        }).frame(height: 50)
        .confirmationDialog("Submit Report",
                            isPresented: $isShowingSubmitConfirmation, titleVisibility: .visible) {
            Button("Submit", role: .none) {
                submitReport()
            }
        } message: {
            Text("Are you sure you want to submit this report?")
        }
    }
    
    private func loadData() {
        self.isLoading = true
        guard let accessToken = authManager.accessToken else {
            print("Access token not found")
            return
        }
        dao.fetchReportItems(reportId: report.id, accessToken: accessToken) { result in
            switch result {
            case .success(let items):
                self.expenseItems = items
            case .failure(let error):
                print("Failed to fetch items: \(error)")
            }
            self.isLoading = false
        }
    }
    
    private func refreshReport() {
        self.isLoading = true
        guard let accessToken = authManager.accessToken else {
            print("Access token not found")
            return
        }
        dao.fetchReport(reportId: report.id, accessToken: accessToken) { result in
            switch result {
            case .success(let report):
                print("Refreshing report")
                self.report = report
            case .failure(let error):
                print("Failed to fetch report: \(error)")
            }
            self.isLoading = false
        }
    }
    
    private func submitReport() {
        self.isLoading = true
        guard let accessToken = authManager.accessToken else {
            print("Access token not found")
            return
        }
        dao.submitReport(reportId: report.id, accessToken: accessToken) {
            result in
            switch result {
            case .success(let report):
                globalState.showMessage(title: "Success", message: "Successfully submitted report", type: .success)
                self.report = report
            case .failure(_):
                globalState.showMessage(title: "Error", message: "Failed to submit report", type: .error)
            }
            self.isLoading = false
        }
    }
}

#Preview {
    ReportsDetailView(report: .constant(
        Report(
            id: "1",
            user: "something@something.com",
            reportNumber: "RPT123456",
            reportStatus: "Open",
            reportSubmitDate: "2023-01-15",
            integrationStatus: "Not Integrated",
            integrationDate: nil,
            reportDate: "2024-06-08",
            expenseType: "Travel",
            purpose: "Business trip to NYC",
            paymentMethod: "Credit Card",
            reportAmount: "1200.00",
            reportCurrency: "USD",
            createdAt: "2023-01-10T10:00:00Z",
            updatedAt: "2023-01-15T12:00:00Z"
        )))
    .environmentObject(AuthenticationManager())
    .environmentObject(GlobalStateManager())
}
